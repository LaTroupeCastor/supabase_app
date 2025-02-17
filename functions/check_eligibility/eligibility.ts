import {
    EnergyLabelType,
    FiscalIncomeType,
    OccupancyStatusType,
    Simulation,
    WorkType,
    EligibilityResponse,
    AidDetails
} from "./types.ts";

/**
 * Filtre les options de financement additionnelles depuis la base de données
 */
function getAdditionalFundingOptions(aids: AidDetails[]): AidDetails[] {
    return aids.filter((aid: AidDetails) => aid.is_funding_option);
}

/**
 * Interface décrivant une aide à la rénovation énergétique
 * Correspond à la structure de la table aid_details dans la base de données
 */
/**
 * Calcule le montant des CEE selon le type de travaux et les caractéristiques du logement
 */
function calculateCEEAmount(simulation: Simulation): number {
    const BASE_CEE_AMOUNTS: Record<WorkType, number> = {
        [WorkType.ISOLATION]: 2500,
        [WorkType.HEATING]: 4000,
        [WorkType.VENTILATION]: 1500,
        [WorkType.WINDOWS]: 2000,
        [WorkType.GLOBAL_RENOVATION]: 5000,
    };

    if (!simulation.work_type) return 0;

    let amount = BASE_CEE_AMOUNTS[simulation.work_type];

    // Application des bonus
    if (simulation.fiscal_income === FiscalIncomeType.VERY_LOW) {
        amount *= 2;
    } else if (simulation.fiscal_income === FiscalIncomeType.LOW) {
        amount *= 1.5;
    }

    // Ajustement selon la surface
    if (simulation.living_area && simulation.living_area > 100) {
        amount *= (simulation.living_area / 100);
    }

    return Math.round(amount);
}

/**
 * Calcule le montant spécifique pour chaque aide selon ses critères
 */
function calculateSpecificAidAmount(
    aid: AidDetails,
    simulation: Simulation,
    incomeBracket: { min: number; max: number | null }
): number {
    switch (aid.name) {
        case 'Aide départementale Maine-et-Loire':
            if (simulation.department === '49' &&
                (simulation.energy_label === EnergyLabelType.F_G)) {
                return simulation.biosourced_materials ?
                    aid.default_amount + 500 :
                    aid.default_amount;
            }
            break;


        case 'Aide amélioration énergétique Saumur':
            if (simulation.department === '49') {
                return Math.min(aid.max_amount, aid.default_amount);
            }
            break;

        case 'MaPrimeRenov':
            if (incomeBracket.min < 15262) return aid.max_amount;
            if (incomeBracket.min < 19565) return aid.max_amount * 0.75;
            if (incomeBracket.min < 29148) return aid.max_amount * 0.50;
            return aid.max_amount * 0.25;
    }

    return aid.default_amount;
}

/**
 * Vérifie l'éligibilité aux différentes aides selon les critères de la simulation
 * @param simulation - Les données de simulation fournies par l'utilisateur
 * @param supabaseClient - Client Supabase pour accéder à la base de données
 * @returns Liste des aides éligibles avec leurs montants ajustés
 */
export async function checkEligibility(simulation: Simulation, supabaseClient: any): Promise<EligibilityResponse> {
    // Fonction interne pour déterminer la tranche de revenus selon les plafonds
    /**
     * Détermine les seuils de revenus selon la tranche fiscale
     * @param fiscalIncome - Tranche de revenus déclarée
     * @returns Bornes min et max de la tranche
     */
    const getIncomeBracket = (fiscalIncome: FiscalIncomeType): { min: number; max: number | null } => {
        const INCOME_BRACKETS = {
            [FiscalIncomeType.VERY_LOW]: { min: 0, max: 15262 },
            [FiscalIncomeType.LOW]: { min: 15262, max: 19565 },
            [FiscalIncomeType.MEDIUM]: { min: 19565, max: 29148 },
            [FiscalIncomeType.HIGH]: { min: 29148, max: 38184 },
            [FiscalIncomeType.VERY_HIGH]: { min: 38184, max: null }
        };

        const bracket = INCOME_BRACKETS[fiscalIncome];
        if (!bracket) throw new Error('Invalid fiscal income type');
        return bracket;
    };

    // Calcul de la tranche de revenus du ménage
    const incomeBracket = getIncomeBracket(simulation.fiscal_income!);

    // Récupération de toutes les aides disponibles depuis la base de données
    const { data: aids, error } = await supabaseClient
        .from('aid_details')
        .select('*');

    if (error) throw new Error('Failed to fetch aid details');

    // Filtrage des aides selon les critères d'éligibilité
    const eligibleAids = aids.filter((aid: AidDetails) => {
        // Exclure les options de financement
        if (aid.is_funding_option) return false;
        
        // Vérification des critères de base (revenus, âge du bâtiment, statut d'occupation, type de travaux)
        if (aid.min_income && incomeBracket.min < aid.min_income) return false;
        if (aid.max_income && incomeBracket.max && incomeBracket.max > aid.max_income) return false;
        if (aid.building_age_over_15 !== undefined && aid.building_age_over_15 !== simulation.building_age_over_15) return false;
        if (aid.occupancy_status_required && !aid.occupancy_status_required.includes(simulation.occupancy_status!)) return false;
        if (aid.allowed_work_types && !aid.allowed_work_types.includes(simulation.work_type!)) return false;

        // Vérification des critères géographiques (département 49 - Maine et Loire)
        if (aid.name.includes('département') && simulation.department !== '49') return false;
        if (aid.name.includes('Saumur') && simulation.department !== '49') return false;
        if (aid.name.includes('Angers') && simulation.department !== '49') return false;

        return true;
    }).map((aid: AidDetails) => {
        let adjustedAmount = aid.default_amount;

        if (aid.name === 'Certificats d\'Économies d\'Énergie') {
            adjustedAmount = calculateCEEAmount(simulation);
        } else {
            adjustedAmount = calculateSpecificAidAmount(aid, simulation, incomeBracket);
        }

        return {
            ...aid,
            adjusted_amount: Number(adjustedAmount.toFixed(2))
        };
    });

    const response = {
        eligible_aids: eligibleAids,
        additional_funding_options: getAdditionalFundingOptions(aids),
        available_aids_info: aids.map((aid: AidDetails) => ({
            name: aid.name,
            description: aid.description,
            organization: aid.funding_organization,
            more_info_url: aid.more_info_url || ""
        }))
    };

    if (simulation.email) {
        try {
            const totalAmount = eligibleAids.reduce((sum: number, aid: AidDetails & { adjusted_amount: number }) => sum + aid.adjusted_amount, 0);

            const emailResponse = await fetch('https://api.resend.com/emails', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    Authorization: `Bearer ${Deno.env.get('RESEND_API_KEY')}`
                },
                body: JSON.stringify({
                    from: 'contact@latroupecastor.fr',
                    to: simulation.email,
                    subject: 'Résultats de votre simulation - La Troupe Castor',
                    html: `
                    <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px; border: 1px solid #eee; border-radius: 5px;">
                        <h2 style="color: #333; border-bottom: 2px solid #ddd; padding-bottom: 10px;">Résultats de votre simulation</h2>
                        
                        <div style="margin: 20px 0;">
                            <p style="font-weight: bold; margin: 5px 0;">Montant total des aides potentielles :</p>
                            <p style="margin: 5px 0; font-size: 24px; color: #2ecc71;">${totalAmount.toLocaleString('fr-FR')} €</p>
                        </div>

                        <div style="margin: 20px 0;">
                            <p style="font-weight: bold; margin: 5px 0;">Aides auxquelles vous pourriez être éligible :</p>
                            ${eligibleAids.map((aid: AidDetails & { adjusted_amount: number }) => `
                                <div style="margin: 10px 0; padding: 10px; background-color: #f9f9f9; border-radius: 5px;">
                                    <p style="font-weight: bold; margin: 5px 0;">${aid.name}</p>
                                    <p style="margin: 5px 0;">${aid.description}</p>
                                    <p style="margin: 5px 0; color: #2ecc71;">Montant estimé : ${aid.adjusted_amount.toLocaleString('fr-FR')} €</p>
                                    ${aid.more_info_url ? `<a href="${aid.more_info_url}" style="color: #3498db;">Plus d'informations</a>` : ''}
                                </div>
                            `).join('')}
                        </div>

                        <div style="margin-top: 30px; font-size: 12px; color: #666; border-top: 1px solid #eee; padding-top: 10px;">
                            <p>Ces résultats sont donnés à titre indicatif et ne constituent pas un engagement définitif.</p>
                            <p>Pour plus d'informations, n'hésitez pas à nous contacter.</p>
                        </div>
                    </div>
                    `
                }),
            });
            await emailResponse.text(); // Consommer le corps de la réponse
        } catch (error) {
            console.error('Erreur lors de l\'envoi de l\'email:', error);
        }
    }

    return response;
}

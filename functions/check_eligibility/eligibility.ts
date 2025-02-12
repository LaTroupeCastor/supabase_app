import { EnergyLabelType, FiscalIncomeType, OccupancyStatusType, Simulation, WorkType } from "./types.ts";

/**
 * Retourne les options de financement additionnelles selon le statut d'occupation
 */
function getAdditionalFundingOptions(simulation: Simulation) {
    return [
        {
            name: "Eco-PTZ (Éco-Prêt à Taux Zéro)",
            description: "Prêt sans intérêts jusqu'à 50 000€ pour financer vos travaux de rénovation énergétique",
            conditions: [
                "Logement construit avant 1990",
                "Propriétaires occupants ou bailleurs",
                "Pas de conditions de ressources",
                "Pour isolation, chauffage, fenêtres"
            ],
            more_info_url: "https://www.economie.gouv.fr/particuliers/eco-pret-a-taux-zero-ptz"
        },
        ...(simulation.occupancy_status === OccupancyStatusType.OWNER_LESSOR ? [{
            name: "Solibail",
            description: "Dispositif permettant de louer votre bien à une association qui garantit le paiement du loyer",
            conditions: [
                "Location à une association agréée",
                "Bail de 3 ans renouvelable",
                "Garantie du paiement des loyers",
                "Accompagnement par l'association"
            ],
            more_info_url: "https://www.service-public.fr/particuliers/vosdroits/F33778"
        }] : []),
        ...(simulation.occupancy_status === OccupancyStatusType.CO_OWNER ? [{
            name: "Aides spécifiques copropriétés",
            description: "Des aides collectives existent pour les copropriétés votant des travaux de rénovation énergétique",
            conditions: [
                "Vote des travaux en assemblée générale nécessaire",
                "Accompagnement possible par un syndic",
                "Cumul possible des aides individuelles et collectives"
            ],
            more_info_url: "https://www.anah.fr/copropriete"
        }] : [])
    ];
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
            if (simulation.department === '49' && simulation.energy_label === EnergyLabelType.F) {
                return simulation.biosourced_materials ?
                    aid.default_amount + 500 :
                    aid.default_amount;
            }
            break;

        case 'Aide Mieux chez Moi':
            if (simulation.department === '49') {
                return aid.default_amount;
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

interface AidDetails {
    id: string;
    name: string;
    description: string;
    max_amount: number;
    default_amount: number;
    funding_organization: string;
    required_documents: string[];
    min_income?: number;
    max_income?: number;
    building_age_over_15?: boolean;
    occupancy_status_required?: OccupancyStatusType[];
    allowed_work_types?: WorkType[];
}

/**
 * Interface décrivant le résultat du calcul d'éligibilité
 * Étend AidDetails avec des montants ajustés et des options de financement additionnelles
 */
interface EligibilityResult {
    id: string;
    name: string;
    description: string;
    max_amount: number;
    default_amount: number;
    adjusted_amount: number;
    funding_organization: string;
    required_documents: string[];
    additional_funding_options?: {
        name: string;
        description: string;
        conditions: string[];
        more_info_url?: string;
    }[];
}

/**
 * Vérifie l'éligibilité aux différentes aides selon les critères de la simulation
 * @param simulation - Les données de simulation fournies par l'utilisateur
 * @param supabaseClient - Client Supabase pour accéder à la base de données
 * @returns Liste des aides éligibles avec leurs montants ajustés
 */
export async function checkEligibility(simulation: Simulation, supabaseClient: any): Promise<EligibilityResult[]> {
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
    return aids.filter((aid: AidDetails) => {
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

        // Calcul du montant CEE si applicable
        if (aid.name === 'Certificats d\'Économies d\'Énergie') {
            adjustedAmount = calculateCEEAmount(simulation);
        }
        // Calcul des montants ajustés pour chaque aide selon leurs critères spécifiques
        // Aide départementale : bonus matériaux biosourcés
        // MaPrimeRenov : dégressif selon revenus
        // Aides locales : plafonds spécifiques
        // Calcul des montants pour les autres aides
        else {
            adjustedAmount = calculateSpecificAidAmount(aid, simulation, incomeBracket);
        }

        return {
            ...aid,
            adjusted_amount: Number(adjustedAmount.toFixed(2))
        };
    }).map((result: AidDetails & { adjusted_amount: number }) => ({
        ...result,
        additional_funding_options: getAdditionalFundingOptions(simulation)
    }));
}

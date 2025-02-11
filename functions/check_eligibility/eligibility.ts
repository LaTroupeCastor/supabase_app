import { EnergyLabelType, FiscalIncomeType, OccupancyStatusType, Simulation, WorkType } from "./types.ts";

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

interface EligibilityResult {
    id: string;
    name: string;
    description: string;
    max_amount: number;
    default_amount: number;
    adjusted_amount: number;
    funding_organization: string;
    required_documents: string[];
}

export async function checkEligibility(simulation: Simulation, supabaseClient: any): Promise<EligibilityResult[]> {
    // Déterminer la tranche de revenus
    const getIncomeBracket = (fiscalIncome: FiscalIncomeType) => {
        switch (fiscalIncome) {
            case FiscalIncomeType.VERY_LOW: return { min: 0, max: 15262 };
            case FiscalIncomeType.LOW: return { min: 15262, max: 19565 };
            case FiscalIncomeType.MEDIUM: return { min: 19565, max: 29148 };
            case FiscalIncomeType.HIGH: return { min: 29148, max: 38184 };
            case FiscalIncomeType.VERY_HIGH: return { min: 38184, max: null };
            default: throw new Error('Invalid fiscal income type');
        }
    };

    const incomeBracket = getIncomeBracket(simulation.fiscal_income!);

    // Récupérer toutes les aides disponibles
    const { data: aids, error } = await supabaseClient
        .from('aid_details')
        .select('*');

    if (error) throw new Error('Failed to fetch aid details');

    // Filtrer et ajuster les aides selon les critères
    return aids.filter((aid: AidDetails) => {
        // Vérification des critères de base
        if (aid.min_income && incomeBracket.min < aid.min_income) return false;
        if (aid.max_income && incomeBracket.max && incomeBracket.max > aid.max_income) return false;
        if (aid.building_age_over_15 !== undefined && aid.building_age_over_15 !== simulation.building_age_over_15) return false;
        if (aid.occupancy_status_required && !aid.occupancy_status_required.includes(simulation.occupancy_status!)) return false;
        if (aid.allowed_work_types && !aid.allowed_work_types.includes(simulation.work_type!)) return false;

        // Vérification des critères géographiques
        if (aid.name.includes('département') && simulation.department !== '49') return false;
        if (aid.name.includes('Saumur') && simulation.department !== '49') return false;
        if (aid.name.includes('Angers') && simulation.department !== '49') return false;

        return true;
    }).map((aid: AidDetails) => {
        let adjustedAmount = aid.default_amount;

        // Calcul des montants ajustés
        if (aid.name === 'Aide départementale Maine-et-Loire' &&
            simulation.department === '49' &&
            simulation.energy_label === EnergyLabelType.F) {
            adjustedAmount = simulation.biosourced_materials ?
                aid.default_amount + 500 :
                aid.default_amount;
        } else if (aid.name === 'Aide Mieux chez Moi' && simulation.department === '49') {
            adjustedAmount = aid.default_amount;
        } else if (aid.name === 'Aide amélioration énergétique Saumur' && simulation.department === '49') {
            adjustedAmount = Math.min(aid.max_amount, aid.default_amount);
        } else if (aid.name === 'MaPrimeRenov') {
            if (incomeBracket.min < 15262) adjustedAmount = aid.max_amount;
            else if (incomeBracket.min < 19565) adjustedAmount = aid.max_amount * 0.75;
            else if (incomeBracket.min < 29148) adjustedAmount = aid.max_amount * 0.50;
            else adjustedAmount = aid.max_amount * 0.25;
        }

        return {
            ...aid,
            adjusted_amount: Number(adjustedAmount.toFixed(2))
        };
    });
}

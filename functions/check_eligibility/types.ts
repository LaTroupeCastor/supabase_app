/**
 * Étiquettes énergétiques possibles pour un logement
 * Regroupées en trois catégories : A à E, F/G, ou inconnue
 */
export enum EnergyLabelType {
    A_B_C_D_E = 'A_B_C_D_E',
    F_G = 'F_G',
    UNKNOWN = 'UNKNOWN'
}

/**
 * Tranches de revenus fiscaux des ménages
 * Utilisées pour déterminer l'éligibilité et les montants des aides
 */
export enum FiscalIncomeType {
    VERY_LOW = "very_low",
    LOW = "low",
    MEDIUM = "medium",
    HIGH = "high",
    VERY_HIGH = "very_high",
}

/**
 * Statuts d'occupation possibles
 * Détermine les aides accessibles et les options de financement
 */
export enum OccupancyStatusType {
    OWNER_OCCUPANT = 'owner_occupant',
    OWNER_LESSOR = 'owner_lessor',
    TENANT = 'tenant',
    CO_OWNER = 'co_owner',
}

/**
 * Types de travaux de rénovation énergétique
 * Utilisés pour le calcul des aides et l'estimation des CEE
 */
export enum WorkType {
    ISOLATION = 'isolation',
    HEATING = 'heating',
    VENTILATION = 'ventilation',
    WINDOWS = 'windows',
    GLOBAL_RENOVATION = 'global'
}

/**
 * Interface principale de simulation
 * Contient toutes les informations fournies par l'utilisateur
 * nécessaires au calcul d'éligibilité aux aides
 */
export interface Simulation {
    id: string;
    current_step: number;
    current_sub_step: number;
    session_token: string;
    expiration_date: Date;
    created_at?: Date;
    updated_at?: Date;
    department: string | "49";
    email: string | null;
    anah_aid_last_5_years?: boolean;
    biosourced_materials?: boolean;
    building_age_over_15?: boolean;
    energy_diagnostic_done?: boolean;
    energy_label?: EnergyLabelType;
    fiscal_income?: FiscalIncomeType;
    occupancy_status?: OccupancyStatusType;
    work_type?: WorkType;
    living_area?: number | null;
    name: string;
    subname: string;
}

export interface AidDetails {
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
    more_info_url?: string;
    is_funding_option?: boolean;
}

/**
 * Interface décrivant le résultat du calcul d'éligibilité
 */
export interface EligibilityResult {
    id: string;
    name: string;
    description: string;
    max_amount: number;
    default_amount: number;
    adjusted_amount: number;
    funding_organization: string;
    required_documents: string[];
}

/**
 * Interface décrivant la réponse complète du calcul d'éligibilité
 */
export interface EligibilityResponse {
    eligible_aids: EligibilityResult[];
    additional_funding_options: {
        name: string;
        description: string;
        conditions: string[];
        more_info_url?: string;
    }[];
    available_aids_info: {
        name: string;
        description: string;
        organization: string;
        more_info_url: string;
    }[];
}

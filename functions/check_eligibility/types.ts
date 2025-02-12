/**
 * Étiquettes énergétiques possibles pour un logement
 * Regroupées par paires pour simplifier (A/B, C/D, F/G)
 */
export enum EnergyLabelType {
    A_B = 'A_B',
    C_D = 'C_D',
    E = 'E',
    F = 'F_G',
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

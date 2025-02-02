export enum EnergyLabelType {
    A_B = 'A_B',
    C_D = 'C_D',
    E = 'E',
    F = 'F_G',
    UNKNOWN = 'UNKNOWN'
}

export enum FiscalIncomeType {
    VERY_LOW = "very_low",
    LOW = "low",
    MEDIUM = "medium",
    HIGH = "high",
    VERY_HIGH = "very_high",
}

export enum OccupancyStatusType {
    OWNER_OCCUPANT = 'owner_occupant',
    OWNER_LESSOR = 'owner_lessor',
    TENANT = 'tenant',
    CO_OWNER = 'co_owner',
}

export enum WorkType {
    ISOLATION = 'isolation',
    HEATING = 'heating',
    VENTILATION = 'ventilation',
    WINDOWS = 'windows',
    GLOBAL_RENOVATION = 'global'
}

export interface Simulation {
    id: string;
    current_step: number;
    current_sub_step: number;
    session_token: string;
    expiration_date: Date;
    created_at?: Date;
    updated_at?: Date;
    department: string | null;
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
}

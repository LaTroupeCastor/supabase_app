import { corsHeaders } from "../_shared/cors.ts";
import { createClient } from "jsr:@supabase/supabase-js@2";
import { Simulation } from "./types.ts";

Deno.serve(async (req) => {
    // Gestion CORS preflight
    const origin = req.headers.get('origin') ?? undefined;
    const headers = corsHeaders(origin);

    if (req.method === 'OPTIONS') {
        return new Response('ok', { headers });
    }

    // Vérification méthode POST uniquement
    if (req.method !== 'POST') {
        return new Response(
            JSON.stringify({ error: 'Méthode non autorisée' }),
            { headers: new Headers(headers), status: 405 }
        );
    }

    try {
        const body = await req.json();

        if (!body || typeof body !== 'object') {
            throw new Error('Le corps de la requête doit être un objet JSON valide');
        }

        if (!body.simulation_id) {
            throw new Error('Le paramètre simulation_id est requis');
        }

        const { simulation_id } = body;

        if (typeof simulation_id !== 'string') {
            throw new Error('Le simulation_id doit être une chaîne de caractères');
        }

        // Création du client Supabase
        const supabaseClient = createClient(
            Deno.env.get('SUPABASE_URL') ?? '',
            Deno.env.get('SUPABASE_ANON_KEY') ?? '',
            {
                auth: {
                    persistSession: false
                }
            }
        );

        // Récupération de la simulation
        const { data: rawSimulation, error } = await supabaseClient
            .from('aid_simulation')
            .select('*')
            .eq('id', simulation_id)
            .single();

        if (error) {
            throw new Error('Erreur lors de la récupération de la simulation: ' + error.message);
        }

        if (!rawSimulation) {
            throw new Error('Simulation non trouvée');
        }

        // Conversion des dates
        const simulation: Simulation = {
            ...rawSimulation,
            expiration_date: new Date(rawSimulation.expiration_date),
            created_at: rawSimulation.created_at ? new Date(rawSimulation.created_at) : undefined,
            updated_at: rawSimulation.updated_at ? new Date(rawSimulation.updated_at) : undefined,
        };

        // Vérification des champs requis
        const requiredFields = [
            'anah_aid_last_5_years',
            'biosourced_materials',
            'building_age_over_15',
            'energy_diagnostic_done',
            'energy_label',
            'fiscal_income',
            'occupancy_status',
            'work_type',
            'email',
            'name',
            'subname'
        ];

        const missingFields = requiredFields.filter(field => 
            simulation[field as keyof Simulation] === undefined || 
            simulation[field as keyof Simulation] === null
        );

        if (missingFields.length > 0) {
            throw new Error(`Formulaire incomplet. Champs manquants : ${missingFields.join(', ')}`);
        }
        return new Response(
            JSON.stringify({
                success: true,
                data: simulation
            }),
            {
                headers: new Headers({
                    ...headers,
                    'Content-Type': 'application/json'
                }),
                status: 200
            }
        );

    } catch (error: any) {
        return new Response(
            JSON.stringify({
                success: false,
                error: error.message
            }),
            {
                headers: new Headers({
                    ...headers,
                    'Content-Type': 'application/json'
                }),
                status: 400
            }
        );
    }
});

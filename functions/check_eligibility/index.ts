import { corsHeaders } from "../_shared/cors.ts";
import { createClient } from "jsr:@supabase/supabase-js@2";

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
        const { data: simulation, error } = await supabaseClient
            .from('aid_simulation')
            .select('*')
            .eq('id', simulation_id)
            .single();

        if (error) {
            throw new Error('Erreur lors de la récupération de la simulation: ' + error.message);
        }

        if (!simulation) {
            throw new Error('Simulation non trouvée');
        }

        // Ici, vous pourrez ajouter la logique d'éligibilité
        // Pour l'instant, on renvoie juste les données de la simulation
        return new Response(
            JSON.stringify({
                success: true,
                data: simulation
            }),
            {
                headers: new Headers(headers),
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
                headers: new Headers(headers),
                status: 400
            }
        );
    }
});

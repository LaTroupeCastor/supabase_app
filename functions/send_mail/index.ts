import { corsHeaders } from "../_shared/cors.ts";

Deno.serve(async (req) => {
    // Gestion CORS preflight
// Convertir null en undefined pour correspondre au type attendu
    const origin = req.headers.get('origin') ?? undefined;
    const headers = corsHeaders(origin);

    if (req.method === 'OPTIONS') {
        return new Response('ok', { headers: headers });
    }

    // Vérification méthode POST uniquement
    if (req.method !== 'POST') {
        return new Response(
            JSON.stringify({ error: 'Méthode non autorisée' }),
            { headers: new Headers(headers), status: 405 }
        );
    }

    try {
        const { emailFrom, message } = await req.json();

        // Validation des données requises
        if (!emailFrom || !message) {
            throw new Error('Email et message sont requis');
        }

        const res = await fetch('https://api.resend.com/emails', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                Authorization: `Bearer ${Deno.env.get('RESEND_API_KEY')}`
            },
            body: JSON.stringify({
                from: 'contact@latroupecastor.fr',
                to: 'contact@latroupecastor.fr',
                subject: `Message from ${emailFrom}`,
                html: '<strong>it works! message: </strong>' + message,
            }),
        });

        const resendData = await res.json();

        return new Response(
            JSON.stringify({
                success: res.ok,
                data: resendData
            }),
            {
                headers: new Headers(headers),
                status: res.ok ? 200 : resendData.statusCode || 500
            }
        );

    } catch (error : any) {
        return new Response(
            JSON.stringify({ success: false, error: error.message }),
            { headers: new Headers(headers), status: 400 }
        );
    }
});

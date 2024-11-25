import { corsHeaders } from "../_shared/cors.ts";

Deno.serve(async (req) => {
    // Gestion des OPTIONS pour CORS
    if (req.method === 'OPTIONS') {
        return new Response(null, { ...corsHeaders , status: 204 });
    }

    // Vérification de la méthode
    if (req.method !== 'POST') {
        return new Response(
            JSON.stringify({ success: false, error: 'Méthode non autorisée' }),
            { ...corsHeaders , status: 405 }
        );
    }

    try {
        const { emailFrom, message } = await req.json();

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
            { ...corsHeaders , status: res.ok ? 200 : resendData.statusCode || 500 }
        );

    } catch (error : any) {
        return new Response(
            JSON.stringify({
                success: false,
                error: error.message
            }),
            { ...corsHeaders , status: 500 }
        );
    }
});

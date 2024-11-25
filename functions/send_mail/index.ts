import { Request, Response } from 'https://deno.land/x/oak/mod.ts'

const RESEND_API_KEY = Deno.env.get('RESEND_API_KEY')

const handler = async (request: Request): Promise<Response> => {
    // Vérifier si c'est une requête POST
    if (request.method !== 'POST') {
        return new Response('Méthode non autorisée', { status: 405 });
    }

    try {
        // Récupérer le body de la requête
        const body = await request.json();
        console.log(body);
        const { emailFrom, message } = body;

        const res = await fetch('https://api.resend.com/emails', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                Authorization: `Bearer ${RESEND_API_KEY}`,
            },
            body: JSON.stringify({
                from: 'contact@latroupecastor.fr',
                to: 'contact@latroupecastor.fr',
                subject: `Message from ${emailFrom}`,
                html: '<strong>it works! message: </strong>' + message,
            }),
        });

        const data = await res.json();

        // Vérifier si la réponse contient une erreur
        if (!res.ok || data.statusCode >= 400) {
            console.error(data);
            return new Response(JSON.stringify({
                error: data.message || 'Une erreur est survenue lors de l\'envoi de l\'email'
            }), {
                status: data.statusCode || 500,
                headers: {
                    'Content-Type': 'application/json',
                },
            });
        }

        return new Response(JSON.stringify(data), {
            status: 200,
            headers: {
                'Content-Type': 'application/json',
            },
        });
    } catch (error) {
        return new Response(JSON.stringify({ error: error.message }), {
            status: 400,
            headers: {
                'Content-Type': 'application/json',
            },
        });
    }
};

Deno.serve(handler)

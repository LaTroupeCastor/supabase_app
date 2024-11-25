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
        const { emailFrom, message, name, subname, phone } = await req.json();

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
                subject: `Message from ${name} ${subname}`,
                html: `                                                                                                                                                                           
     <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px; border: 1px solid #eee; border-radius: 5px;">                                    
         <h2 style="color: #333; border-bottom: 2px solid #ddd; padding-bottom: 10px;">Nouveau message de contact</h2>                                                             
                                                                                                                                                                                   
         <div style="margin: 20px 0;">                                                                                                                                             
             <p style="font-weight: bold; margin: 5px 0;">De :</p>                                                                                                                 
             <p style="margin: 5px 0;">${name} ${subname}</p>                                                                                                                      
         </div>                                                                                                                                                                    
                                                                                                                                                                                   
         <div style="margin: 20px 0;">                                                                                                                                             
             <p style="font-weight: bold; margin: 5px 0;">Email :</p>                                                                                                              
             <p style="margin: 5px 0;">${emailFrom}</p>                                                                                                                            
         </div>                                                                                                                                                                    
                                                                                                                                                                                   
         ${phone ? `                                                                                                                                                               
         <div style="margin: 20px 0;">                                                                                                                                             
             <p style="font-weight: bold; margin: 5px 0;">Téléphone :</p>                                                                                                          
             <p style="margin: 5px 0;">${phone}</p>                                                                                                                                
         </div>                                                                                                                                                                    
         ` : ''}                                                                                                                                                                   
                                                                                                                                                                                   
         <div style="margin: 20px 0;">                                                                                                                                             
             <p style="font-weight: bold; margin: 5px 0;">Message :</p>                                                                                                            
             <p style="margin: 5px 0; white-space: pre-wrap;">${message}</p>                                                                                                       
         </div>                                                                                                                                                                    
                                                                                                                                                                                   
         <div style="margin-top: 30px; font-size: 12px; color: #666; border-top: 1px solid #eee; padding-top: 10px;">                                                              
             <p>Ce message a été envoyé depuis le formulaire de contact de La Troupe Castor</p>                                                                                    
         </div>                                                                                                                                                                    
     </div>                                                                                                                                                                        
 `,
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

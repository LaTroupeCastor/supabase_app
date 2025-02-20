import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import {AidDetails} from "../check_eligibility/types.ts";

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

console.log("Starting email function..."); // Log initial

serve(async (req) => {
  console.log("Received request"); // Log request reception

  if (req.method === 'OPTIONS') {
    console.log("OPTIONS request received");
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    console.log("Parsing request body..."); // Log avant parsing
    const { email, eligibleAids, additionalFundingOptions, totalAmount, simulationId } = await req.json()
    console.log("Request body parsed:", { email, totalAmount, simulationId }); // Log après parsing

    console.log("RESEND_API_KEY present:", !!Deno.env.get('RESEND_API_KEY')); // Vérifier la clé API

    console.log("Preparing to send email..."); // Log avant envoi
    const emailResponse = await fetch('https://api.resend.com/emails', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${Deno.env.get('RESEND_API_KEY')}`
      },
      body: JSON.stringify({
        from: 'contact@latroupecastor.fr',
        to: email,
        subject: 'Résultats de votre simulation - La Troupe Castor',
        html: `<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>La Troupe Castor - Résultats de simulation</title>
</head>
<body style="margin: 0; padding: 0; font-family: Arial, Helvetica, sans-serif;">
    <div style="max-width: 600px; background-color: #FCEECF; margin: 0 auto; padding: 20px;">
        <div style="text-align: center; margin-bottom: 30px;">
            <img src="https://vjvvhynmroaefrrawflu.supabase.co/storage/v1/object/public/images//logo_name.png" alt="La Troupe Castor" style="max-width: 200px;">
        </div>

        <div style="text-align: center; padding-bottom: 64px;">
            <p style="font-size: 20px; font-weight: 400; color: #140E00; width: 70%; margin: 0 auto;"><span style="font-weight: 500;">Cher utilisateur, </span>merci d'avoir utilisé notre simulateur d'aide à la rénovation.</p> 
        </div>
        <div style="padding: 0 10% 20px 10%;">
            <p style="font-size: 12px; font-weight: 400; color: #140E00; width: 70%; margin: 0;">Selon votre simulation, vous pourriez bénéficier de plusieurs dispositifs d'aide pour votre projet !</p>
        </div>
        <div style="background-color: #F1AB0E; width: 100%; color:#FEFBF3; padding: 32px 0; position: relative;">                   
            <div style="padding: 0 10%;">                                                                                                           
                <p style="font-size: 24px; font-weight: 600; margin: 0;">${totalAmount ? totalAmount.toLocaleString('fr-FR') : 0} €</p>             
                <p style="font-size: 24px; font-weight: 400; margin: 0;">d'aides possibles</p>           
                <p style="font-size: 12px; font-weight: 400; color:#F9DD9F; margin: 0;">Estimation préliminaire</p>                                                         
            </div>                                                                                                                                                         
            <img src="https://vjvvhynmroaefrrawflu.supabase.co/storage/v1/object/public/images//beavy.png" style="position: absolute; right: 0; bottom: 0; transform: translateY(-20%); width: 35%;">                                                                            
        </div> 

        <div style="padding: 32px 10%;">
            <p style="font-size: 16px; font-weight: 500; margin: 0;">Liste de vos aides potentielles</p>
            <p style="font-size: 12px; font-weight: 400; color: #F1AB0E; padding-bottom: 24px; margin: 0;">Être accompagné d'un conseiller pour faire la demande</p>
            ${eligibleAids.map((aid: AidDetails & { adjusted_amount: number }) => `
            <div style="border: 1px solid #F1AB0E; border-radius: 4px; padding: 16px 12px; background-color: white; margin-bottom: 16px;">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 8px;">
                    <p style="font-size: 16px; font-weight: 500; margin: 0;">${aid.name}</p>
                    <span style="color: #C8C7C4;">jusqu'à ${aid.adjusted_amount ? aid.adjusted_amount.toLocaleString('fr-FR') : 0} €</span>
                </div>
                <p style="font-size: 12px; font-weight: 400; margin: 0 0 8px 0;">${aid.description}</p>
                ${aid.more_info_url ? `<a href="${aid.more_info_url}" style="font-size: 12px; font-weight: 400; color: #F1AB0E; text-decoration: none;">En savoir plus</a>` : ''}
            </div>
            `).join('')}
        </div>
        <div style="padding: 0 10%;">
            <p style="font-size: 16px; font-weight: 500; margin: 0; padding-bottom: 24px;">Liste des options de financements complémentaires éligibles</p>
             ${additionalFundingOptions.map((option: AidDetails) => `
             <div style="border-radius: 4px; padding: 16px 12px; background-color: white; margin-bottom: 16px;">
                 <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 8px;">
                     <p style="font-size: 16px; font-weight: 500; margin: 0;">${option.name}</p>
                     <span style="color: #C8C7C4;">jusqu'à ${option.max_amount ? option.max_amount.toLocaleString('fr-FR') : 'N/A'} €</span>
                 </div>
                 <p style="font-size: 12px; font-weight: 400; margin: 0 0 8px 0;">${option.description}</p>
                 ${option.more_info_url ? `<a href="${option.more_info_url}" style="font-size: 12px; font-weight: 400; color: #F1AB0E; text-decoration: none;">En savoir plus</a>` : ''}
             </div>
             `).join('')}
        </div>
        <div style="padding: 0 10%;">
            <div style="margin-top: 50px; margin-bottom: 22px;">
                <div style="text-align: center;">
                    <a href="${Deno.env.get('FRONTEND_URL')}/inscription?simulation=${simulationId}" style="font-size: 16px; font-weight: 500; background-color: #F1AB0E; color: #FEFBF3; padding: 12px 24px; border-radius: 4px; text-decoration: none; display: inline-block; margin-bottom: 22px;">Finalisez votre inscription et demandez vos aides</a>
                </div>
                <p style="font-size: 12px; font-weight: 400; color: #6E6B62; text-align: left; margin: 0;">La troupe castor vous permet de vous accompagner pour vos demandes d'aides et de vous mettre directement en relation avec des artisans RGE pour faciliter vos projets de rénovation</p>
            </div>
        </div>
    </div>
</body>
</html>
        `
      }),
    })

    console.log('Resend Response Status:', emailResponse.status);
    const responseText = await emailResponse.text();
    console.log('Resend Response Body:', responseText);

    return new Response(JSON.stringify({ success: true }), {
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      status: 200,
    })
  } catch (error: unknown) {
    console.error("Error in email function:", error); // Log des erreurs
    const errorMessage = error instanceof Error ? error.message : 'Une erreur inconnue est survenue';
    return new Response(JSON.stringify({error: errorMessage}), {
      headers: {...corsHeaders, 'Content-Type': 'application/json'},
      status: 400,
    })
  }
})

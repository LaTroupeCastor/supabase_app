import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import {AidDetails} from "../check_eligibility/types.ts";

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    const { email, eligibleAids, additionalFundingOptions, totalAmount, simulationId } = await req.json()

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
    <title>Exemple</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        .all-page{
            font-family: 'Poppins', sans-serif;
            max-width: 600px;
            background-color: #FCEECF;
            margin: 0 auto;
        }

        .title-medium-medium{
            font-weight: 500;
            font-size: 20px;
            color: #140E00;
        }
        .title-medium-regular{
            font-weight: 400;
            font-size: 20px;
            color: #140E00;
        }
        .body-small-regular{
            font-size: 12px;
            font-weight: 400;
            color: #140E00;
        }
        .head-name{
            text-align: center;
            align-items: center;
            display: flex;
            justify-content: center;
        }
        .body-medium-medium{
            font-size: 16px;
            font-weight: 500;
        }
        .title-large-sbold{
            font-size: 24px;
            font-weight: 600;
        }
        .title-large-regular{
            font-size: 24px;
            font-weight: 400;
        }
        .body-small-regular{
            font-size: 12px;
            font-weight: 400;
        }
        .body{
            padding: 0px 10%;
        }
        .button{
            background-color: #F1AB0E;
            color: #FEFBF3;
            padding: 12px 24px;
            border-radius: 4px;
            text-decoration: none;
            display: inline-block;
        }
        p {                                                                                                                          
            margin: 0;
        }     
    </style>
</head>
<body>
    <div class="all-page">
        <div style="text-align: center; margin-bottom: 30px;">
            <img src="https://vjvvhynmroaefrrawflu.supabase.co/storage/v1/object/public/images//logo_name.png" alt="La Troupe Castor">
        </div>

        <div class="head-name" style="padding-bottom: 64px;">
            <p class="title-medium-regular" style="width:70%;"><span class="title-medium-medium">Cher utilisateur, </span>merci d'avoir utilisé notre simulateur d'aide à la rénovation.</p> 
        </div>
        <div class="body"  style="padding-bottom: 20px;">
            <p class="body-small-regular" style="width: 70%;">Selon votre simulation, vous pourriez bénéficier de plusieurs dispositifs d'aide pour votre projet !</p>
        </div>
        <div style="background-color: #F1AB0E; width: 100%; color:#FEFBF3; padding-top: 32px; padding-bottom: 32px; position: relative;">                   
            <div style="display: flex; flex-direction: column;" class="body">                                                                                                           
                <p class="title-large-sbold" style="margin: 0;">${totalAmount.toLocaleString('fr-FR')} €</p>             
                <p class="title-large-regular">d'aides possibles</p>           
                <p class="body-small-regular" style="color:#F9DD9F; margin: 0;">Estimation préliminaires </p>                                                         
            </div>                                                                                                                                                         
            <img src="https://vjvvhynmroaefrrawflu.supabase.co/storage/v1/object/public/images//beavy.png" style="position: absolute; right: 0; bottom: 0; transform: translateY(-20%);width: 35%;">                                                                            
        </div> 

        <div style="padding: 32px 10%;">
            <p class="body-medium-medium">Liste de vos potentiels aides</p>
            <p style="color: #F1AB0E; padding-bottom: 24px;" class="body-small-regular">Être accompagné d'un conseillé pour faire la demande</p>
            
            ${eligibleAids.map((aid: AidDetails & { adjusted_amount: number }) => `
            <div style="border: 1px solid #F1AB0E; border-radius: 4px; padding: 16px 12px; background-color: white; margin-bottom: 16px;">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 8px;">
                    <p class="body-medium-medium">${aid.name}</p>
                    <span style="color: #C8C7C4;">jusqu'à ${aid.adjusted_amount.toLocaleString('fr-FR')} €</span>
                </div>
                <p style="margin: 0 0 8px 0;" class="body-small-regular">${aid.description}</p>
                ${aid.more_info_url ? `<a href="${aid.more_info_url}" class="body-small-regular" style="color: #F1AB0E;">En savoir plus</a>` : ''}
            </div>
            `).join('')}
        </div>
        <div class="body">
            <p class="body-medium-medium" style="padding-bottom: 24px;">Liste des options de financements complémentaires éligibles</p>
            ${additionalFundingOptions.map((option: AidDetails) => `
            <div style="border-radius: 4px; padding: 16px 12px; background-color: white; margin-bottom: 16px;">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 8px;">
                    <p class="body-medium-medium">${option.name}</p>
                    <span style="color: #C8C7C4;">jusqu'à ${option.max_amount.toLocaleString('fr-FR')} €</span>
                </div>
                <p style="margin: 0 0 8px 0;" class="body-small-regular">${option.description}</p>
                ${option.more_info_url ? `<a href="${option.more_info_url}" class="body-small-regular" style="color: #F1AB0E;">En savoir plus</a>` : ''}
            </div>
            `).join('')}
        </div>
        <div class="body">
            <div style="display: flex;flex-direction: column; margin-top: 50px; margin-bottom: 22px; text-align: center; margin-left:1rem; margin-right: 1rem;">
                <a href="${Deno.env.get('FRONTEND_URL')}/inscription?simulation=${simulationId}" class="body-medium-medium button" style="margin-bottom: 22px;">Finalisez votre inscription et demandez vos aides</a>
                <p class="body-small-regular" style="color: #6E6B62; text-align: left;">La troupe castor vous permet de vous accompagner pour vos demandes d'aides et de vous mettre directement en relation avec des artisans RGE pour faciliter vos projets de rénovation</p>
            </div>
        </div>
    </div>
</body>
</html>
        `
      }),
    })

    const result = await emailResponse.text()

    return new Response(JSON.stringify({ success: true }), {
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      status: 200,
    })
  } catch (error: unknown) {
    const errorMessage = error instanceof Error ? error.message : 'Une erreur inconnue est survenue';
    return new Response(JSON.stringify({ error: errorMessage }), {
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      status: 400,
    })
  }
})

import { serve } from "https://deno.land/std@0.168.0/http/server.ts"

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    const { email, eligibleAids, additionalFundingOptions, totalAmount } = await req.json()

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
        html: `
          <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px; border: 1px solid #eee; border-radius: 5px;">
            <h2 style="color: #333; border-bottom: 2px solid #ddd; padding-bottom: 10px;">Résultats de votre simulation</h2>
            
            <div style="margin: 20px 0;">
              <p style="font-weight: bold; margin: 5px 0;">Montant total des aides potentielles :</p>
              <p style="margin: 5px 0; font-size: 24px; color: #2ecc71;">${totalAmount.toLocaleString('fr-FR')} €</p>
            </div>

            <div style="margin: 20px 0;">
              <p style="font-weight: bold; margin: 5px 0;">Aides auxquelles vous pourriez être éligible :</p>
              ${eligibleAids.map((aid) => `
                <div style="margin: 10px 0; padding: 10px; background-color: #f9f9f9; border-radius: 5px;">
                  <p style="font-weight: bold; margin: 5px 0;">${aid.name}</p>
                  <p style="margin: 5px 0;">${aid.description}</p>
                  <p style="margin: 5px 0; color: #2ecc71;">Montant estimé : ${aid.adjusted_amount.toLocaleString('fr-FR')} €</p>
                  ${aid.more_info_url ? `<a href="${aid.more_info_url}" style="color: #3498db;">Plus d'informations</a>` : ''}
                </div>
              `).join('')}
            </div>

            <div style="margin: 20px 0;">
              <p style="font-weight: bold; margin: 5px 0;">Options de financement complémentaires :</p>
              ${additionalFundingOptions.map((option) => `
                <div style="margin: 10px 0; padding: 10px; background-color: #f8f8f8; border-radius: 5px; border-left: 3px solid #3498db;">
                  <p style="font-weight: bold; margin: 5px 0;">${option.name}</p>
                  <p style="margin: 5px 0;">${option.description}</p>
                  ${option.more_info_url ? `<a href="${option.more_info_url}" style="color: #3498db;">Plus d'informations</a>` : ''}
                </div>
              `).join('')}
            </div>

            <div style="margin-top: 30px; font-size: 12px; color: #666; border-top: 1px solid #eee; padding-top: 10px;">
              <p>Ces résultats sont donnés à titre indicatif et ne constituent pas un engagement définitif.</p>
              <p>Pour plus d'informations, n'hésitez pas à nous contacter.</p>
            </div>
          </div>
        `
      }),
    })

    const result = await emailResponse.text()
    
    return new Response(JSON.stringify({ success: true }), {
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      status: 200,
    })
  } catch (error) {
    return new Response(JSON.stringify({ error: error.message }), {
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      status: 400,
    })
  }
})

const allowedOrigins = [
    'http://localhost:5173',
    'https://latroupecastor.fr',
    'https://latroupecastor.com'
];

export const corsHeaders = (requestOrigin?: string) => {
    // Si l'origine n'est pas dans la liste, on retourne une erreur
    if (!requestOrigin || allowedOrigins.indexOf(requestOrigin) === -1) {
        throw new Error('Origin not allowed');
    }

    return {
        'Access-Control-Allow-Origin': requestOrigin,
        'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
        'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
        'Access-Control-Allow-Credentials': 'true',
    }
};

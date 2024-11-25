const allowedOrigins = [
    'http://localhost:5173',
    'https://latroupecastor.fr',
    'https://latroupecastor.com'
];

export const corsHeaders = (requestOrigin?: string) => {
    const origin = requestOrigin && allowedOrigins.indexOf(requestOrigin) !== -1
        ? requestOrigin
        : allowedOrigins[0];

    return {
        'Access-Control-Allow-Origin': origin,
        'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
        'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
        'Access-Control-Allow-Credentials': 'true',
    }
};

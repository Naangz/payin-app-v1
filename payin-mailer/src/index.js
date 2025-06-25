/**
 * Welcome to Cloudflare Workers! This is your first worker.
 *
 * - Run `npm run dev` in your terminal to start a development server
 * - Open a browser tab at http://localhost:8787/ to see your worker in action
 * - Run `npm run deploy` to publish your worker
 *
 * Learn more at https://developers.cloudflare.com/workers/
 */

const cors = {
  'Access-Control-Allow-Origin':  '*',          // ganti ke origin spesifik di produksi
  'Access-Control-Allow-Methods': 'POST, OPTIONS',
  'Access-Control-Allow-Headers': 'Content-Type',
};

export default {
  async fetch(request, env) {

    // 1. pre-flight
    if (request.method === 'OPTIONS') {
      return new Response(null, { status: 204, headers: cors });
    }

    // 2. hanya izinkan POST
    if (request.method !== 'POST') {
      return new Response('Method Not Allowed', { status: 405, headers: cors });
    }

    // 3. ambil payload
    const { to, subject, html, pdf } = await request.json();

    // 4. forward ke MailerSend
    const msResp = await fetch('https://api.mailersend.com/v1/email', {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${env.MAILERSEND_KEY}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        from: { email: 'no-reply@test-r83ql3pe750gzw1j.mlsender.net', name: 'pay.in (Demo)' },
        to: [{ email: to }],
        subject,
        html,
        ...(pdf && {
          attachments: [{
            filename: 'invoice.pdf',
            content: pdf,
            type: 'application/pdf',
          }],
        }),
      }),
    });

    // 5. teruskan respons + header CORS
    return new Response(await msResp.text(), {
      status: msResp.status,
      headers: { ...cors, 'Content-Type': 'application/json' },
    });
  },
};

/**
 * Welcome to Cloudflare Workers! This is your first worker.
 *
 * - Run `npm run dev` in your terminal to start a development server
 * - Open a browser tab at http://localhost:8787/ to see your worker in action
 * - Run `npm run deploy` to publish your worker
 *
 * Learn more at https://developers.cloudflare.com/workers/
 */

export default {
  async fetch(request, env, ctx) {
    if (request.method !== 'POST') {
      return new Response('Method Not Allowed', { status: 405 });
    }

    // ambil JSON body
    const { to, subject, html, pdf } = await request.json();

    // forward ke MailerSend
    const resp = await fetch('https://api.mailersend.com/v1/email', {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${env.MAILERSEND_KEY}`,
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        from: { email: 'no-reply@test-r83ql3pe750gzw1j.mlsender.net', name: 'pay.in' },
        to: [{ email: to }],
        subject,
        html,
        ...(pdf && {
          attachments: [{
            filename: 'invoice.pdf',
            content: pdf,             // base64 dari Flutter
            type: 'application/pdf'
          }]
        })
      })
    });

    // teruskan body & status MailerSend apa adanya
    return new Response(await resp.text(), { status: resp.status });
  }
};

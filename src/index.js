/**
 * Responds to any HTTP request.
 *
 * @param {!express:Request} req HTTP request context.
 * @param {!express:Response} res HTTP response context.
 */

const functions = require('@google-cloud/functions-framework');

functions.http('main', (req, res) => {
  if (!process.env.VERSION) {
    throw new Error('VERSION is not defined in the environment variable');
  }

  res.status(200).send('<h1>Cloud Function version ' + process.env.VERSION + '</h1>');
});

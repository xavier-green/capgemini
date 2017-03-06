var nodemailer = require('nodemailer');
var bluebird = require("bluebird");

let email = "cap.setelem@gmail.com";
let pass = "CCmv&mMDP!"
let recipients = [
	"jean-claude.guyard@capgemini.com",
	"xavier.green@student.ecp.fr",
	"younes.belkouchi@student.ecp.fr",
	"florian.nouel@bnpparibas-pf.com",
	"alexandre.coel@cetelem.fr"
]

// create reusable transporter object using the default SMTP transport
var transporter = nodemailer.createTransport('smtps://'+email.replace("@","%40")+':'+pass.replace("@","%40")+'@smtp.gmail.com');

// setup e-mail data with unicode symbols
var mailOptions = {
    from: '', // sender address
    to: recipients.join(","), // list of receivers
    subject: "Erreur d'authentification", // Subject line
    html: '' // html body
};

bluebird.promisifyAll(transporter);

function sendEmail(username,email) {
	let fromString = '"'+username+'" <'+email+'>'
	mailOptions.from = fromString;
	mailOptions.html = "Bonjour,<br/><br/>Je suis <b>"+username+"</b> (email: "+email+")<br/><br/>J'ai eu un problème lors de mon authentification vocale, <br/><br/>Merci de bien vouloir m'aider !";
	return transporter.sendMailAsync(mailOptions);
}

module.exports = sendEmail;
const express = require('express');
const adminController = require('./admin.controller.js');
const router = express.Router(); // eslint-disable-line new-cap

router.route('/')
    .get((req,res,next) => {
    	if (req.session.loggedIn) {
    		return adminController.list()
	    	.then((statsObject) => {
	    		let stats = statsObject.stats
	    		let percentages = statsObject.percentages
	    		res.render('admin',{stats,percentages});
	    	})
	    	.catch((e) => {
	    		res.json(e)
	    	})
    	} else {
    		res.render('error');
    	}
    });

router.route('/login')
	.get((req,res,next) => {
		res.render('login');
	})
	.post((req,res,next) => {
		let username = req.body.login
		let password = req.body.pass
		if (username=="admin" && password=="admin") {
			req.session.loggedIn = true;
			res.redirect('/admin')
		} else {
			res.render('login',{error:"Les identifiants sont faux"})
		}
	})

module.exports = exports = router;

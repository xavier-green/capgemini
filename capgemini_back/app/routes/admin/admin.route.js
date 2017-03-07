const express = require('express');
const adminController = require('./admin.controller.js');
const router = express.Router(); // eslint-disable-line new-cap

router.route('/')
    .get((req,res,next) => {
    	return adminController.list()
    	.then((statsObject) => {
    		let stats = statsObject.stats
    		let percentages = statsObject.percentages
    		res.render('admin',{stats,percentages});
    	})
    	.catch((e) => {
    		res.json(e)
    	})
    });

module.exports = exports = router;

const express = require('express');
const adminController = require('./admin.controller.js');
const router = express.Router(); // eslint-disable-line new-cap

router.route('/')
    .get((req,res,next) => {
    	return adminController.list()
    	.then((stats) => {
    		res.render('admin',{stats});
    	})
    	.catch((e) => {
    		res.json(e)
    	})
    });

module.exports = exports = router;

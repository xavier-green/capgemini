const express = require('express');
const imageController = require('./image.controller');
const router = express.Router(); // eslint-disable-line new-cap

router.route('/')
    .get(imageController.list)
    .post(imageController.add);

router.route('/leader')
    .get(imageController.leader);

router.route('/topimage')
	.post(imageController.getTopImage)

router.route('/:imageId')
    .put(imageController.vote)
    .delete(imageController.remove);

router.route('/getfirst')
	.post(imageController.getFirst)

module.exports = exports = router;

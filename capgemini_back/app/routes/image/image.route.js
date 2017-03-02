const express = require('express');
const imageController = require('./image.controller');
const router = express.Router(); // eslint-disable-line new-cap

router.route('/')
    .get(imageController.list)
    .post(imageController.add);

router.route('/:imageId')
    .put(imageController.vote)
    .delete(imageController.remove);

module.exports = exports = router;

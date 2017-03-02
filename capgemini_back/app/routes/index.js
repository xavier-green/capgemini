const express = require('express');
const userRoutes = require('./user/user.route');
const imageRoutes = require('./image/image.route');

const router = express.Router(); // eslint-disable-line new-cap

/** GET /health-check - Check service health */
router.get('/health-check', (req, res) =>
    res.send('OK')
);

// mount user routes at /users
router.use('/users', userRoutes);

router.use('/images', imageRoutes);

module.exports = exports = router;

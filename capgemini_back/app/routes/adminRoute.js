const express = require('express');
const adminRoutes = require('./admin/admin.route');
const router = express.Router(); // eslint-disable-line new-cap

router.use('/', adminRoutes);

module.exports = exports = router;

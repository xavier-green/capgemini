const express = require('express');
const validate = require('express-validation');
// const paramValidation = require('./user.validation');
const statCtrl = require('./stat.controller');
const router = express.Router(); // eslint-disable-line new-cap
router.route('/')
    /** GET /api/users - Get list of users */
    .get(statCtrl.list)
    /** POST /api/users - Create new user */
    .post(statCtrl.create);

router.route('/:statId')
    /** GET /api/users/:userId - Get user */
    .get(statCtrl.get)
    // /** PUT /api/users/:userId - Update user */
    // .put(userCtrl.update)
    /** DELETE /api/users/:userId - Delete user */
    .delete(statCtrl.remove);

router.route('/addHack')
  .post(statCtrl.addHack);

router.route('/hackAttempt')
  .post(statCtrl.hackAttempt);

router.route('/loginSuccess')
  .post(statCtrl.loginSuccess);

router.route('/loginFail')
  .post(statCtrl.loginFail);

/** Load user when API with userId route parameter is hit */
router.param('statId', statCtrl.load);
module.exports = exports = router;

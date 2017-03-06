const User = require('./user.model');
/**
 * Load user and append to req.
 */
function load(req, res, next, username) {
    User.get(username).then((user) => {
        req.user = user;
        return next();
    }).error((e) => {
        e.isPublic = true;
        e.message = 'User not Found';
        return next(e);
    });
}
/**
 * Get user
 * @returns {User}
 */
function get(req, res) {
    return res.json(req.user);
}
/**
 * Create new user
 * @property {string} req.body.username - The username of user.
 * @property {string} req.body.mobileNumber - The mobileNumber of user.
 * @returns {User}
 */
function create(req, res, next) {
    const user = new User({
        username: req.body.username,
        memDate: req.body.memDate,
    });
    user.saveAsync()
        .then((savedUser) => res.json(savedUser))
        .error((e) => res.json(e));
}
/**
 * Update existing user
 * @property {string} req.body.username - The username of user.
 * @property {string} req.body.mobileNumber - The mobileNumber of user.
 * @returns {User}
 */
function update(req, res, next) {
    const user = req.user;
    user.username = req.body.username;
    user.memDate = req.body.memDate;
    user.authNumber = req.body.authNumber;
    user.saveAsync()
        .then((savedUser) => res.json(savedUser))
        .error((e) => next(e));
}
/**
 * Get user list.
 * @property {number} req.query.skip - Number of users to be skipped.
 * @property {number} req.query.limit - Limit number of users to be returned.
 * @returns {User[]}
 */
function list(req, res, next) {
    const { limit = 50, skip = 0 } = req.query;
    User.list({ limit, skip }).then((users) => res.json(users))
        .error((e) => next(e));
}
/**
 * Delete user.
 * @returns {User}
 */
function remove(req, res, next) {
    const user = req.user;
    user.removeAsync()
        .then((deletedUser) => res.json(deletedUser))
        .error((e) => next(e));
}

function verifyDate(req,res) {
  User.findOne({ username:req.body.username })
      .then((user) => {
        if (user.memDate==req.body.memDate) {
          user.authNumber++
          user.saveAsync()
              .error((e)=>(e));
          res.json({username:req.body.username,authorized:true})
        } else {
          res.json({username:req.body.username,authorized:false})
        }
      })
}

function addFrequency(req,res) {
  User.findOne({ username:req.body.username })
      .then((user) => {
        if (user.frequencyParameters.registered==false && req.body.frequency!=null) {
          user.frequencyParameters.frequency=req.body.frequency
          user.frequencyParameters.registered=true
          user.saveAsync()
              .then((savedUser)=>res.json({username:savedUser.username, registered:savedUser.frequencyParameters.registered, frequency:savedUser.frequencyParameters.frequency}))
              .error((e)=>(e));
        } else {
          res.json({username:user.username, registered:user.frequencyParameters.registered, frequency:user.frequencyParameters.frequency})
        }
      })
}

module.exports = exports = { load, get, create, update, list, remove, verifyDate, addFrequency };

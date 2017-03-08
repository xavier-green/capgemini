const Stat = require('./stat.model');
const moment = require('moment');
const sendEmail = require('./../../helpers/Email');
/**
 * Load stat and append to req.
 */
function load(req, res, next, id) {
    Stat.get(id).then((stat) => {
        req.stat = stat;
        return next();
    }).error((e) => {
        e.isPublic = true;
        e.message = 'Stat not Found';
        return next(e);
    });
}
/**
 * Get stat
 * @returns {Stat}
 */
function get(req, res) {
    return res.json(req.stat);
}
/**
 * Create new stat
 * @property {string} req.body.statname - The statname of stat.
 * @property {string} req.body.mobileNumber - The mobileNumber of stat.
 * @returns {Stat}
 */
function create(req, res) {
    const stat = new Stat({
    });
    stat.saveAsync()
        .then((savedStat) => res.json(savedStat))
        .error((e) => res.json(e));
}

function createStat() {
  const stat = new Stat({
  });
  return stat.saveAsync()
}
/**
 * Get stat list.
 * @property {number} req.query.skip - Number of stats to be skipped.
 * @property {number} req.query.limit - Limit number of stats to be returned.
 * @returns {Stat[]}
 */
function list(req, res, next) {
    const { limit = 50, skip = 0 } = req.query;
    Stat.list({ limit, skip }).then((stat) => res.json(stat))
        .error((e) => next(e));
}
/**
 * Delete stat.
 * @returns {Stat}
 */
function remove(req, res, next) {
    const stat = req.stat;
    stat.removeAsync()
        .then((deletedStat) => res.json(deletedStat))
        .error((e) => next(e));
}

function addHack(req,res) {
    var createTodayStat = createStat
    return Stat.findOne({ createdAt:moment().format("DD/MM/YYYY") })
        .then((stat) => {
          if (stat==null) {
              return createTodayStat(req,res)
              .then(()=>loginSuccess(req, res))
          }
          stat.AccountsHacked.push({hacker:req.body.hacker,hacked:req.body.hacked});
          stat.succeededHacks = stat.AccountsHacked.length;
          stat.saveAsync()
              .then((savedStat) => res.json(savedStat))
        })
}

function hackAttempt(req, res, next) {
  var createTodayStat = createStat
  return Stat.findOne({ createdAt:moment().format("DD/MM/YYYY") })
              .then((stat) => {
                if (stat==null) {
                    return createTodayStat(req,res)
                    .then(()=>hackAttempt(req, res))
                }
                stat.attemptedHacks +=1
                stat.saveAsync()
                    .then((savedData) => res.json({message:"Well tried"}))
                    .error((e)=> next(e))
              })

}

function loginSuccess(req, res) {
  console.log("loginSuccess");
  var createTodayStat = createStat
  return Stat.findOne({ createdAt:moment().format("DD/MM/YYYY") })
              .then((stat) => {
                console.log("stat: "+stat);
                if (stat==null) {
                  console.log("stat null, creating it");
                    return createTodayStat(req,res)
                    .then(()=>loginSuccess(req, res))
                }
                console.log("now adding the success");
                stat.AuthNumber.succeeded +=1;
                stat.saveAsync()
                    .then((savedData) => res.end("Successful Login"))
                    .error((e)=> res.json(e))
              })
}

function loginFail(req, res) {
  let email = req.body.email;
  let username = req.body.username;
  console.log("got failure from: "+username+" (email: "+email+")");
  var createTodayStat = createStat
  return Stat.findOne({ createdAt:moment().format("DD/MM/YYYY") })
  .then((stat) => {
    if (stat==null) {
        return createTodayStat(req,res)
        .then(()=>loginFail(req, res))
    }
    stat.AuthNumber.failed +=1;
    stat.saveAsync()
        .then((savedData) => {
          return sendEmail(username, email)
          .then(()=>res.end("Login failed"))
          .catch((er) => {
            console.log(er);
            res.json(er)
          })
        })
        .error((e)=> res.json(e))
  })
}

function loginAttempt(req, res) {
  var createTodayStat = createStat
  return Stat.findOne({ createdAt:moment().format("DD/MM/YYYY") })
              .then((stat) => {
                if (stat==null) {
                    return createTodayStat(req,res)
                    .then(()=>loginAttempt(req, res))
                }
                stat.loginAttempts +=1
                stat.saveAsync()
                    .then((savedData) => res.json({message:"Login Attempted"}))
                    .error((e)=> next(e))
              })
}

function enrolAttempt(req, res) {
  var createTodayStat = createStat
  return Stat.findOne({ createdAt:moment().format("DD/MM/YYYY") })
              .then((stat) => {
                if (stat==null) {
                    return createTodayStat(req,res)
                    .then(()=>enrolAttempt(req, res))
                }
                stat.enrolmentAttempts +=1
                stat.saveAsync()
                    .then((savedData) => res.json({message:"Enrolment Attempted"}))
                    .error((e)=> next(e))
              })
  }



module.exports = exports = { load, get, create, list, remove, addHack, hackAttempt, loginSuccess, loginFail, loginAttempt, enrolAttempt };

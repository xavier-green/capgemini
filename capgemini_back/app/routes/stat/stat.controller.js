const Stat = require('./stat.model');
const moment = require('moment');
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
              .then(() => {return addHack(req,res)} )
          } else {
            stat.AccountsHacked.push({hacker:req.body.hacker,hackee:req.body.hackee});
            stat.numberOfHacks = stat.AccountsHacked.length;
            stat.saveAsync()
                .then((savedStat) => res.json(savedStat))
          }
        })
}
module.exports = exports = { load, get, create, list, remove, addHack };

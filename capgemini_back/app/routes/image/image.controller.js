const Image = require('./image.model');

function list(req, res, next) {
    const { skip = 0, username } = req.query;
    Image.list({ skip, username }).then((images) => {
        console.log("got "+images.count+" images");
        res.json(images)
    })
    .error((e) => res.json(e))
}

function leader(req,res,next) {
    Image.find().sort({votes:-1}).limit(25).execAsync()
    .then((images) => {
        res.json(images);
    })
    .catch((e) => {
        res.json(e)
    })
}

function add(req, res, next) {
    let data = req.body;
    let username = data.username;
    let imageData = data.imageData;
    const image = new Image({
        username,
        imageData,
    });
    image.saveAsync()
        .then((savedImage) => res.json(savedImage))
        .error((e) => res.json(e));
}

function vote(req, res, next) {
    let _id = req.params.imageId;
    return Image.findOneAsync({_id})
    .then((image) => {
        image.votes += 1
        return image.saveAsync()
        .then((imSaved) => {
            res.json(imSaved)
        })
    })
    .error((e) => res.json(e));
}

function remove(req, res, next) {
    let _id = req.params.imageId;
    return Image.find({_id}).remove().execAsync()
    .then((imSaved) => {
        res.json(imSaved)
    })
    .catch((e) => res.json(e));
}

module.exports = exports = { list, add, vote, remove, leader };

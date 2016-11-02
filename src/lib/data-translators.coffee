_ = require('lodash')
util = require('util')

###
   converts a DynamoDB compatible JSON object into
   a native JSON object
   @param dbObj the dynamodb JSON object
   @throws an error if input object is not compatible
   @return res the converted object
###

convertObject = (obj) ->
  converted = {}
  converted[key] = fromDynamo(value) for key, value of obj
  converted

fromDynamo = (dbObj) ->
  if _.isArray dbObj
    obj = []
    for element, key in dbObj
      obj[key] = fromDynamo element
    return obj
  if _.isObject dbObj
    if dbObj.M
      return convertObject(dbObj.M)
    else if(dbObj.BOOL?)
      return dbObj.BOOL
    else if(dbObj.S)
      return dbObj.S
    else if(dbObj.SS)
      return dbObj.SS
    else if(dbObj.N?)
      return parseFloat(dbObj.N)
    else if(dbObj.NS)
      return _.map(dbObj.NS, parseFloat)
    else if(dbObj.L)
      return _.map(dbObj.L, fromDynamo)
    else if(dbObj.NULL)
      return null
    else
      return convertObject(dbObj)
  else
    return dbObj

module.exports.fromDynamo = fromDynamo

# See http://vq.io/19EiASB
toDynamo = (item) ->
  if _.isArray item
    # We always use lists for arrays. Sets are too problematic as they are not ordered. 
    array = []
    for value in item
      array.push(toDynamo(value))
    obj =
      'L': array
  else if _.isNumber item
    obj =
      'N': item.toString()
  else if _.isString item
    if item.length is 0
      NULL: true
    else
      S: item
  else if _.isBoolean item
    obj =
      'BOOL': item
  else if _.isObject item
    map = {}
    for key, value of item
      map[key] = toDynamo(value)
    obj =
      'M': map
  else if !item?
    obj =
      'NULL': true


module.exports.toDynamo = toDynamo

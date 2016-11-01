(function() {
  var convertObject, fromDynamo, toDynamo, util, _;

  _ = require('lodash');

  util = require('util');


  /*
     converts a DynamoDB compatible JSON object into
     a native JSON object
     @param dbObj the dynamodb JSON object
     @throws an error if input object is not compatible
     @return res the converted object
   */

  convertObject = function(obj) {
    var converted, key, value;
    converted = {};
    for (key in obj) {
      value = obj[key];
      converted[key] = fromDynamo(value);
    }
    return converted;
  };

  fromDynamo = function(dbObj) {
    var element, key, obj, _i, _len;
    if (_.isArray(dbObj)) {
      obj = [];
      for (key = _i = 0, _len = dbObj.length; _i < _len; key = ++_i) {
        element = dbObj[key];
        obj[key] = fromDynamo(element);
      }
      return obj;
    }
    if (_.isObject(dbObj)) {
      if (dbObj.M) {
        return convertObject(dbObj.M);
      } else if ((dbObj.BOOL != null)) {
        return dbObj.BOOL;
      } else if (dbObj.S) {
        return dbObj.S;
      } else if (dbObj.SS) {
        return dbObj.SS;
      } else if ((dbObj.N != null)) {
        return parseFloat(dbObj.N);
      } else if (dbObj.NS) {
        return _.map(dbObj.NS, parseFloat);
      } else if (dbObj.L) {
        return _.map(dbObj.L, fromDynamo);
      } else if (dbObj.NULL) {
        return null;
      } else {
        return convertObject(dbObj);
      }
    } else {
      return dbObj;
    }
  };

  module.exports.fromDynamo = fromDynamo;

  toDynamo = function(item) {
    var array, key, map, num, obj, value, _i, _len;
    if (_.isArray(item)) {
      if (item.length > 0 && (_.uniq(item).length === item.length) && _.every(item, function(item) {
        return _.isNumber(item) || (_.isString(item) && item.length > 0);
      })) {
        if (_.every(item, _.isNumber)) {
          return obj = {
            'NS': (function() {
              var _i, _len, _results;
              _results = [];
              for (_i = 0, _len = item.length; _i < _len; _i++) {
                num = item[_i];
                _results.push(num.toString());
              }
              return _results;
            })()
          };
        } else if (_.every(item, _.isString)) {
          return obj = {
            'SS': item
          };
        }
      } else {
        array = [];
        for (_i = 0, _len = item.length; _i < _len; _i++) {
          value = item[_i];
          array.push(toDynamo(value));
        }
        return obj = {
          'L': array
        };
      }
    } else if (_.isNumber(item)) {
      return obj = {
        'N': item.toString()
      };
    } else if (_.isString(item)) {
      if (item.length === 0) {
        return {
          NULL: true
        };
      } else {
        return {
          S: item
        };
      }
    } else if (_.isBoolean(item)) {
      return obj = {
        'BOOL': item
      };
    } else if (_.isObject(item)) {
      map = {};
      for (key in item) {
        value = item[key];
        map[key] = toDynamo(value);
      }
      return obj = {
        'M': map
      };
    } else if (item == null) {
      return obj = {
        'NULL': true
      };
    }
  };

  module.exports.toDynamo = toDynamo;

}).call(this);

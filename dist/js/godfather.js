var Godfather;

Godfather = function(endpoint, scope, options) {
  this.endpoint = endpoint;
  this.scope = scope || {};
  this.options = options || {};
  this.extra_find_scopes = this.options.extra_find_scopes || [];
  this.records = [];
  this.seeds = [];
  this.properties = [];
};

Godfather.API_URL = "";

Godfather.prototype.request = function(action, params) {
  return $.post(this.url(action), this.data(params), 'json');
};

Godfather.prototype.promise = function(result) {
  var deferred;
  deferred = $.Deferred();
  deferred.resolve(result);
  return deferred.promise();
};

Godfather.prototype.where = function(params) {
  var _this;
  _this = this;
  return this.request('where', params).then(function(records) {
    var computed_records;
    records = records.concat(_this.seeds);
    computed_records = _.map(records, function(record) {
      return _this.withComputedProps(record);
    });
    _this.properties = _.keys(records[0]);
    _this.records = _.sortBy(computed_records, 'id');
    return _this.promise(_this.records);
  });
};

Godfather.prototype.find = function(id) {
  var _this;
  _this = this;
  return this.where({
    id: id
  }).then(function() {
    return _this.promise(_this.take(id));
  });
};

Godfather.prototype.findBy = function(params) {
  var _this;
  _this = this;
  return this.where(params).then(function(resp) {
    return _this.promise(_.first(_.values(resp)));
  });
};

Godfather.prototype.create = function(params) {
  return this.requestAndRefresh('create', params);
};

Godfather.prototype.update = function(params) {
  return this.requestAndRefresh('update', params);
};

Godfather.prototype.destroy = function(params) {
  return this.requestAndRefresh('destroy', params);
};

Godfather.prototype.take = function(id) {
  return _.detect(this.records, function(record) {
    return parseInt(record.id) === parseInt(id);
  });
};

Godfather.prototype.takeAll = function() {
  return this.records;
};

Godfather.prototype.injectSeedRecords = function(records) {
  return this.seeds = records;
};

Godfather.prototype.syncDiff = function(new_records, old_records) {
  var dirty_records, _this;
  _this = this;
  dirty_records = _.select(new_records, function(new_record) {
    var record_with_same_id;
    record_with_same_id = _.detect(old_records, function(old_record) {
      return new_record.id === old_record.id;
    });
    return JSON.stringify(_.pick(record_with_same_id, _this.properties)) !== JSON.stringify(_.pick(new_record, _this.properties));
  });
  return _.each(dirty_records, function(record) {
    return _this.update(record);
  });
};

Godfather.prototype.requestAndRefresh = function(action, params) {
  var _this;
  _this = this;
  return this.request(action, params).then(function(resp) {
    if (!(resp != null ? resp.success : void 0)) {
      throw new Error('Error in the backend');
    }
    return _this.where().then(function() {
      if (resp.id) {
        return _this.promise(_this.take(resp.id));
      } else {
        return _this.promise(resp.success);
      }
    });
  });
};

Godfather.prototype.withComputedProps = function(record) {
  if (this.computed) {
    return _.extend(record, this.computed(record));
  } else {
    return record;
  }
};

Godfather.prototype.url = function(action) {
  return "" + Godfather.API_URL + "/" + this.endpoint + "/" + action;
};

Godfather.prototype.data = function(params) {
  return {
    scope: JSON.stringify(this.scope),
    extra_find_scopes: JSON.stringify(this.extra_find_scopes),
    data: JSON.stringify(params)
  };
};
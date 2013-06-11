
//= require env

//= require ../../app/assets/javascripts/preload_store.js

// probe framework first
//= require ../../app/assets/javascripts/discourse/components/probes.js

// Externals we need to load first
//= require ../../app/assets/javascripts/external/jquery-1.9.1.js

//= require hacks
//= require ../../app/assets/javascripts/external/jquery.ui.widget.js
//= require ../../app/assets/javascripts/external/handlebars-1.0.rc.4.js
//= require ../../app/assets/javascripts/external_development/ember.js
//= require ../../app/assets/javascripts/external_development/group-helper.js

//= require ../../app/assets/javascripts/locales/i18n
//= require ../../app/assets/javascripts/locales/date_locales.js
//= require ../../app/assets/javascripts/discourse/helpers/i18n_helpers
//= require ../../app/assets/javascripts/locales/en
//
// Pagedown customizations
//= require ../../app/assets/javascripts/pagedown_custom.js

// The rest of the externals
//= require_tree ../../app/assets/javascripts/external

//= require ../../app/assets/javascripts/discourse

// Stuff we need to load first
//= require main_include

//= require admin

//= require_tree ../../app/assets/javascripts/defer


//= require_tree .



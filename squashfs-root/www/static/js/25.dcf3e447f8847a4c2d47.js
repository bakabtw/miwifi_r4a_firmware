webpackJsonp([25],{"4uQT":function(n,a,t){"use strict";var e={name:"headers",props:{name:{type:String,default:""},controlers:{type:String,default:""},step:{type:Number,default:1},fontsize:{type:String,default:"init"}},data:function(){return{stepMap:1}},methods:{back:function(){this.currentStep>1?this.$emit("goBack",--this.currentStep):1==this.currentStep&&history.go(-1)}},computed:{currentStep:{get:function(){return this.stepMap},set:function(n){this.stepMap=n}}},watch:{step:function(n){this.stepMap=n}}},s={render:function(){var n=this,a=n.$createElement,t=n._self._c||a;return t("div",{staticClass:"header"},[t("div",{staticClass:"title",class:{title26:"index"==n.fontsize}},[t("span",{staticClass:"iconfont fanhuijian",class:{iconfont26:"index"==n.fontsize},on:{click:n.back}}),n._v(" "),t("h3",{class:{font26:"index"==n.fontsize}},[n._v(n._s(n.name))])])])},staticRenderFns:[]};var i=t("VU/8")(e,s,!1,function(n){t("bMf1")},null,null);a.a=i.exports},UjGY:function(n,a,t){"use strict";Object.defineProperty(a,"__esModule",{value:!0});var e={name:"switchuser",data:function(){return{operator_lists:[{name:"English",lang:"en"},{name:"العربية",lang:"ar"},{name:"Nederlands",lang:"du"},{name:"Português (Brasil)",lang:"br"},{name:"Français",lang:"fr"},{name:"Español (América)",lang:"ls"},{name:"Deutsch",lang:"ge"},{name:"Dansk",lang:"da"},{name:"Español (España)",lang:"sp"},{name:"Suomi",lang:"fi"},{name:"Indonesia",lang:"id"},{name:"עברית",lang:"he"},{name:"Italiano",lang:"it"},{name:"Bahasa Melayu",lang:"ma"},{name:"Norsk bokmål",lang:"no"},{name:"Polski",lang:"po"},{name:"Русский",lang:"ru"},{name:"Svenska",lang:"sw"},{name:"ไทย",lang:"th"},{name:"Türkçe",lang:"tu"},{name:"Українська",lang:"uk"},{name:"Tiếng Việt",lang:"vi"},{name:"한국어",lang:"ko"},{name:"Português (Portugal)",lang:"pt"}]}},methods:{selectCountry:function(n){this.$i18n.locale=n.lang,this.$router.push({path:"/user",query:{name:n.name,lang:n.lang}})},back:function(){this.$router.push({path:"/user"})}},components:{Header:t("4uQT").a}},s={render:function(){var n=this,a=n.$createElement,t=n._self._c||a;return t("div",{staticClass:"container"},[t("div",{staticClass:"header"},[t("div",{staticClass:"title"},[t("span",{staticClass:"iconfont fanhuijian",on:{click:n.back}})])]),n._v(" "),t("ul",{staticClass:"operators"},n._l(n.operator_lists,function(a){return t("li",{on:{click:function(t){return n.selectCountry(a)}}},[t("a",[t("div",{staticClass:"name"},[n._v("\n                  "+n._s(a.name)+"\n              ")]),n._v(" "),n._m(0,!0)])])}),0)])},staticRenderFns:[function(){var n=this.$createElement,a=this._self._c||n;return a("div",{staticClass:"tel"},[a("div",{staticClass:"iconfont icon-fanhui"})])}]};var i=t("VU/8")(e,s,!1,function(n){t("sedz")},"data-v-0399cbe8",null);a.default=i.exports},bMf1:function(n,a){},sedz:function(n,a){}});
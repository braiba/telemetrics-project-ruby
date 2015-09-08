!function() {
    floow.url = {

        /**
         * Builds a url with a query string
         *
         * @param {string} baseUrl the base url
         * @param {array} params  the query params
         *
         * @returns {string}
         */
        build: function(baseUrl, params)
        {
            var queryParts = [];
            for (i in params) {
                var param = params[i]
                queryParts.push(param[0] + '=' + encodeURIComponent(param[1]));
            }
            return baseUrl + '?' + queryParts.join('&');
        }
    };
}();
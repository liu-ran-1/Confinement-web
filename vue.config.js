let proxyObj = {};
const CompressionPlugin = require("compression-webpack-plugin");
proxyObj['/ws'] = {
    ws: true,
    target: "ws://82.156.187.67:8081"
};
proxyObj['/'] = {
    ws: false,
    target: 'http://82.156.187.67:8081',
    changeOrigin: true,
    pathRewrite: {
        '^/': ''
    }
}
module.exports = {
    devServer: {
        host: 'localhost',
        port: 9999,
        proxy: proxyObj
    },
    assetsDir:'static',
    configureWebpack: config => {
        if (process.env.NODE_ENV === 'production') {
            return {
                plugins: [
                    new CompressionPlugin({
                        test: /\.js$|\.html$|\.css/,
                        threshold: 1024,
                        deleteOriginalAssets: false
                    })
                ]
            }
        }
    }
}
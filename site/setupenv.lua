-- set search path for 'require()'
package.path =
    "common/?.lua;rocks/share/lua/5.1/?.lua;libs/?.lua;analytics/?.lua;apps/?.lua;bitnami/?.lua;databases/?.lua;cache/?.lua;queue;/?.lua;webserver/?.lua;" ..
    package.path

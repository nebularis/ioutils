# ioutils

This library contains various *io* system utilities.

## Resource Resolver

The various scopes available are:

- `loaded` - resources that have been loaded by the runtime system
    - applies to: *applications, modules*
- `installed` - resources that are available to (i.e., installed in) the runtime system
    - applies to: *applications, modules, resource bundles*
- `application` - resources that are *scoped to* a specific application
    - applies to: *all resource types*
    - NOTE: the `application` to which this scope is applied must be *discoverable* via the `loaded` or `installed` scope
- `remote` - resources that can be *discovered* via a *Remote Resource Provider*
    - applies to: *all resource types*

Search Targets consist of:

- `location` - node
- `identifier` - uniquely identifies a *resource*
    - application: name, version, publisher
    - module: name, version, publisher
    - function: module + name, arity
    - [remote] pid/port: registered-name
    - [remote] cache-entry: bucket + key/id

Search Terms:

- `glob` - matches a *glob expression* (possibly containing wildcards) to a search target
    - application example (inline version match): `ioutils-1.*`
    - application example (version agnostic): `rebar_*_plugin`
- `identifier` - matches an explicit `atom` or a `glob` to a search target's identifier
    - applies to: application, module, function, pid/port, cache-entry
- 

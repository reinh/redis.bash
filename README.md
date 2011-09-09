redis.bash - A Redis client
===========================

usage: redis.bash \<ARGS\>

CAVEATS
-------

- requires a bash with /dev/tcp enabled. Older debians/Ubuntus disabled /dev/tcp.
- does not (yet) handle multi-bulk replies.
- does not (yet) allow configuration of redis host or port

EXIT VALUES
-----------

- 0: Success
- 1: Redis error
- 2: Unknown response

TODO
----

- multi-bulk replies
- manpage
- TESTS

LICENSE
-------

MIT, see LICENSE

CONTRIBUTORS
------------

- Rein Henrichs: <reinh@reinh.com>

= AIRBRUSH

== DESCRIPTION

Airbrush is a distributed processing host for performing arbitrary tasks on a particular server.
Currently it supports using MemCache as the transport queue to communicate between an airbrush
server issuing a command and the server processing it.

Due to the distributed nature of MemCache, multiple Airbrush servers can be started across
many hosts, and each will monitor the MemCache incoming queue for results independently and
atomically.

Remote jobs are performed via a 'processor' installed as part of Airbrush, and is currently
configured in code in the server.rb source file (look for the handler definition/configuration). A
future enhancemnt could support automatic processor registration and/or a plugin architecture.

Actual communication between client and server via MemCache is done via a hash, that includes
a :command value, optional :args value and a uniqie :id value. The :id value is used to uniquely
identify this job, :command names the actual command to run on the remote server, and :params
is a hash of parameters that are passed to the command being executed.

Several conventions are used, the name of the command needs to match a method name on the
processor. The key names in the params hash need to match parameter names to the method being
invoked (and will be automatically assigned). The :id value is used to name a queue that the
client can poll for return values from the remote command, if required.

== USAGE

To use Airbrush, you will need a starling server installed and running:

    $> starling -v -P /tmp/starling.pid -q /tmp/queue

and at least one Airbrush instance running, including your processor:

    $> airbrush -v

To send a remote job to the Airbrush server, use the Airbrush::Client module located
in airbrush/client.rb. An example is airbrush-example-client, which sends an image to the
remote server to be turned into a set of previews.

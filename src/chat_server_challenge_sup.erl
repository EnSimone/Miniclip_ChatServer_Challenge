%%%-------------------------------------------------------------------
%% @doc chat_server_challenge top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(chat_server_challenge_sup).

-behaviour(supervisor).

-export([start_link/0]).

-export([init/1]).

-define(SERVER, ?MODULE).

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

%% sup_flags() = #{strategy => strategy(),         % optional
%%                 intensity => non_neg_integer(), % optional
%%                 period => pos_integer()}        % optional
%% child_spec() = #{id => child_id(),       % mandatory
%%                  start => mfargs(),      % mandatory
%%                  restart => restart(),   % optional
%%                  shutdown => shutdown(), % optional
%%                  type => worker(),       % optional
%%                  modules => modules()}   % optional
init([]) ->
    SupFlags = #{strategy => one_for_all,
                 intensity => 0,
                 period => 1},
    ChildSpecs = [#{id => user_sup_id,
                  start => {user_supervisor, start_link, []},
                  restart =>  permanent,
                  shutdown => 2000,
                  type => supervisor,
                  modules => [user_supervisor]},
                  #{id => room_sup_id,
                  start => {room_supervisor, start_link, []},
                  restart =>  permanent,
                  shutdown => 2000,
                  type => supervisor,
                  modules => [room_supervisor]},
                  #{id => list_room_sup_id,
                  start => {list_rooms_supervisor, start_link, []},
                  restart =>  permanent,
                  shutdown => 2000,
                  type => supervisor,
                  modules => [list_rooms_supervisor]}],
    {ok, {SupFlags, ChildSpecs}}.

%% internal functions

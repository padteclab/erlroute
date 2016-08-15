PROJECT = erlroute

DEPS = teaser

dep_teaser = git https://github.com/spylik/teaser master

TEST_DEPS = poolboy

#ifeq ($(USER),travis)
    TEST_DEPS += coveralls-erl ecoveralls
    dep_coveralls-erl = git https://github.com/markusn/coveralls-erl master
	dep_ecoveralls = git https://github.com/nifoc/ecoveralls master
#endif

SHELL_DEPS = sync lager

SHELL_OPTS = -pa ebin/ test/ -env ERL_LIBS deps -eval 'code:ensure_loaded(erlroute_app),code:ensure_loaded(erlroute_tests),lager:start()' -run mlibs autotest_on_compile
#SHELL_OPTS = -pa ebin/ test/ -env ERL_LIBS deps -eval 'code:ensure_loaded(erlroute_app),code:ensure_loaded(erlroute_tests),lager:start()'

include erlang.mk

sendcoverreport: 
	erl -noshell -pa ebin/ test/ -env ERL_LIBS deps -eval 'coveralls:convert_and_send_file("eunit.coverdata",os:getenv("TRAVIS_JOB_ID"),"travis-ci")'

sendcoverreport2:
	erl -noshell -pa ebin/ test/ -env ERL_LIBS deps -eval 'ecoveralls:travis_ci("eunit.coverdata"),init:stop()'

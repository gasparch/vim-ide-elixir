# frozen_string_literal: true

require 'spec_helper'

describe 'transforms ctags output' do
  it "generates trace file" do
    correct_content = <<~EOF
Server	/tmp/v3hvNb9/5.ex	/^defmodule PusherProxy.Proxy.Server do$/;"	m	line:3
start_link/2	/tmp/v3hvNb9/5.ex	/^  def start_link(name, kw_args\\\\[]) do$/;"	f	line:59
add_worker/2	/tmp/v3hvNb9/5.ex	/^  def add_worker(pid, worker_pid) do$/;"	f	line:63
add_worker/3	/tmp/v3hvNb9/5.ex	/^  def add_worker(pid, worker_pid, options) do$/;"	f	line:66
more_work_available?/3	/tmp/v3hvNb9/5.ex	/^  def more_work_available?(pid, worker_pid, since_rev_id) do$/;"	f	line:68
init(kw_args)	/tmp/v3hvNb9/5.ex	/^  def init(kw_args) do$/;"	O	line:73
handle_cast({:add_worker, pid}, state)	/tmp/v3hvNb9/5.ex	/^  def handle_cast({:add_worker, pid}, state) do$/;"	O	line:86
handle_cast({:decoder_ready, decoder_pid}, state)	/tmp/v3hvNb9/5.ex	/^  def handle_cast({:decoder_ready, decoder_pid}, state) do$/;"	O	line:101
handle_cast({:data, _data, false, _rev, _pid}, state)	/tmp/v3hvNb9/5.ex	/^  def handle_cast({:data, _data, false, _rev, _pid}, state) do$/;"	O	line:126
handle_cast({:data, data, true, _rev, _pid}, state)	/tmp/v3hvNb9/5.ex	/^  def handle_cast({:data, data, true, _rev, _pid}, state) do$/;"	O	line:141
handle_cast({:more_work_available?, worker_pid, known_max_rev}, state)	/tmp/v3hvNb9/5.ex	/^  def handle_cast({:more_work_available?, worker_pid, known_max_rev}, state) do$/;"	O	line:172
handle_cast(:cleanup_ets, state)	/tmp/v3hvNb9/5.ex	/^  def handle_cast(:cleanup_ets, state) do$/;"	O	line:188
handle_info({:DOWN, _, :process, pid, reason}, state)	/tmp/v3hvNb9/5.ex	/^  def handle_info({:DOWN, _, :process, pid, reason}, state) do$/;"	O	line:208
handle_info(ev, state)	/tmp/v3hvNb9/5.ex	/^  def handle_info(ev, state) do$/;"	O	line:219
EOF


    expect(<<~EOF).to be_ctags_output(correct_content)
Server	/tmp/v3hvNb9/5.ex	/^defmodule PusherProxy.Proxy.Server do$/;"	m	line:3
start_link	/tmp/v3hvNb9/5.ex	/^  def start_link(name, kw_args\\\\[]) do$/;"	f	line:59
add_worker	/tmp/v3hvNb9/5.ex	/^  def add_worker(pid, worker_pid) do$/;"	f	line:63
add_worker	/tmp/v3hvNb9/5.ex	/^  def add_worker(pid, worker_pid1) do$/;"	f	line:64
add_worker	/tmp/v3hvNb9/5.ex	/^  def add_worker(pid, worker_pid2) do$/;"	f	line:65
add_worker	/tmp/v3hvNb9/5.ex	/^  def add_worker(pid, worker_pid, options) do$/;"	f	line:66
more_work_available?	/tmp/v3hvNb9/5.ex	/^  def more_work_available?(pid, worker_pid, since_rev_id) do$/;"	f	line:68
init(kw_args)	/tmp/v3hvNb9/5.ex	/^  def init(kw_args) do$/;"	O	line:73
init	/tmp/v3hvNb9/5.ex	/^  def init(kw_args) do$/;"	f	line:73
handle_cast({:add_worker, pid}, state)	/tmp/v3hvNb9/5.ex	/^  def handle_cast({:add_worker, pid}, state) do$/;"	O	line:86
handle_cast	/tmp/v3hvNb9/5.ex	/^  def handle_cast({:add_worker, pid}, state) do$/;"	f	line:86
handle_cast({:decoder_ready, decoder_pid}, state)	/tmp/v3hvNb9/5.ex	/^  def handle_cast({:decoder_ready, decoder_pid}, state) do$/;"	O	line:101
handle_cast	/tmp/v3hvNb9/5.ex	/^  def handle_cast({:decoder_ready, decoder_pid}, state) do$/;"	f	line:101
handle_cast({:data, _data, false, _rev, _pid}, state)	/tmp/v3hvNb9/5.ex	/^  def handle_cast({:data, _data, false, _rev, _pid}, state) do$/;"	O	line:126
handle_cast	/tmp/v3hvNb9/5.ex	/^  def handle_cast({:data, _data, false, _rev, _pid}, state) do$/;"	f	line:126
handle_cast({:data, data, true, _rev, _pid}, state)	/tmp/v3hvNb9/5.ex	/^  def handle_cast({:data, data, true, _rev, _pid}, state) do$/;"	O	line:141
handle_cast	/tmp/v3hvNb9/5.ex	/^  def handle_cast({:data, data, true, _rev, _pid}, state) do$/;"	f	line:141
handle_cast({:more_work_available?, worker_pid, known_max_rev}, state)	/tmp/v3hvNb9/5.ex	/^  def handle_cast({:more_work_available?, worker_pid, known_max_rev}, state) do$/;"	O	line:172
handle_cast	/tmp/v3hvNb9/5.ex	/^  def handle_cast({:more_work_available?, worker_pid, known_max_rev}, state) do$/;"	f	line:172
handle_cast(:cleanup_ets, state)	/tmp/v3hvNb9/5.ex	/^  def handle_cast(:cleanup_ets, state) do$/;"	O	line:188
handle_cast	/tmp/v3hvNb9/5.ex	/^  def handle_cast(:cleanup_ets, state) do$/;"	f	line:188
handle_info({:DOWN, _, :process, pid, reason}, state)	/tmp/v3hvNb9/5.ex	/^  def handle_info({:DOWN, _, :process, pid, reason}, state) do$/;"	O	line:208
handle_info	/tmp/v3hvNb9/5.ex	/^  def handle_info({:DOWN, _, :process, pid, reason}, state) do$/;"	f	line:208
handle_info(ev, state)	/tmp/v3hvNb9/5.ex	/^  def handle_info(ev, state) do$/;"	O	line:219
handle_info	/tmp/v3hvNb9/5.ex	/^  def handle_info(ev, state) do$/;"	f	line:219
EOF
  end
end

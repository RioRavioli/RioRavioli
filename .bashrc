#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

export PATH=$PATH:/home/rio/.gem/ruby/1.9.1/bin
export PATH=$PATH:/root/.gem/ruby/1.9.1/bin

export CLASSPATH=$CLASSPATH:/usr/share/java/junit.jar
export CLASSPATH=$CLASSPATH:/usr/share/java/hamcrest.jar

#export JAVA_HOME /usr/lib/jvm
#export PATH=$PATH:$JAVA_HOME/bin

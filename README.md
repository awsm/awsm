[![awsm](https://avatars1.githubusercontent.com/u/19984185?v=3&s=100)](https://github.com/awsm/awsm)
> Make aws more awesome

# 👌 Awsm

Awsm is a helper cli tool with sane defaults that makes AWS even more Awesome.

## Install

```sh
~ λ  brew tap awsm/homebrew-tap
~ λ  brew install awsm
```

## Configure

Check out the [sample_config](sample_config) for configuration options.

## Commands

### SSH

```sh
~ λ  awsm ssh
```

[![asciicast](https://asciinema.org/a/7rjdu1fu7jdrr5rs5mg3s0q3b.png)](https://asciinema.org/a/7rjdu1fu7jdrr5rs5mg3s0q3b)

### Instances

```sh
~ λ  awsm instances
i-z833ec56           ami-z788885d  c3.xlarge   running  Splunk                         2015-03-19T23:08:55.000Z  ap-southeast-2a
i-zec43bff           ami-z6260885  t2.small    running  nagios                         2016-05-30T01:49:00.000Z  ap-southeast-2a
i-z821bdc7           ami-z8d3bc2b  t2.small    stopped  Cachet                         2015-11-11T08:48:03.000Z  ap-southeast-2b
i-zbcd32ca           ami-z82806cb  t2.medium   running  gem-server                     2016-05-29T23:43:10.000Z  ap-southeast-2a
i-z10acf80           ami-a2e3f7c1  c3.2xlarge  running  BuildKite-Agent-production     2016-06-16T12:15:28.000Z  ap-southeast-2a
i-z177544f           ami-z53f67d6  t2.small    stopped  Gem-Server                     2015-11-30T04:04:24.000Z  ap-southeast-2a
i-z97eaef5           ami-z520430f  t2.small    running  GitLab                         2015-03-22T22:47:38.000Z  ap-southeast-2b
i-z2695d9c           ami-z8d38c2b  t2.micro    running  Dns-Services                   2015-12-17T23:54:43.000Z  ap-southeast-2a
i-z1825ddf           ami-z7d8a91d  m3.large    running  Package-BuildHost              2016-06-02T04:08:02.000Z  ap-southeast-2a
i-zfa9449e           ami-z2210191  t2.small    running  Zabbix                         2016-04-15T05:29:01.000Z  ap-southeast-2a
i-ze99db8b           ami-z2d6f7c1  c3.2xlarge  running  BuildKite-Agent-production     2016-06-16T21:00:33.000Z  ap-southeast-2b
i-z999db8c           ami-z2d6f7c1  c3.2xlarge  running  BuildKite-Agent-production     2016-06-16T21:00:33.000Z  ap-southeast-2b
i-zf24deae           ami-zc45b86f  t2.medium   running  hotels-resque-ami-20160614-01  2016-06-14T02:21:07.000Z  ap-southeast-2a
i-ze2d251b           ami-b85900db  m4.large    running  Container-Service              2016-01-20T03:47:13.000Z  ap-southeast-2b
```

### Lambda

```sh
~ λ  awsm lambda-invoke
```

[![asciicast](https://asciinema.org/a/0s7kpmf5oqibzuqv9r9d6p0w3.png?s=1)](https://asciinema.org/a/0s7kpmf5oqibzuqv9r9d6p0w3)


### Logs

```sh
~ λ  awsm logs
```

[![asciicast](https://asciinema.org/a/c3iin8x1tvmb901tevdu6dxdy.png)](https://asciinema.org/a/c3iin8x1tvmb901tevdu6dxdy)

### Cloudformation Stacks

```sh
~ λ  awsm stacks
Build-Farm-Production
Build-Farm-Staging
HoorooNetwork
HoorooSecurity
MailCatcher-Production
MailCatcher-Production-StackApplication-18HDMPF3WZDWQ
```

### Autoscale Groups

```sh
~ λ  awsm asgs
Build-Farm-Production-AppServerGroupDemand-1SZ3RV6YFM36L                           BuildKite-Agent-production
Build-Farm-Production-AppServerGroupSpot-IR14M4M6RE6G                              BuildKite-Agent-production
Build-Farm-Staging-AppServerGroupDemand-17UE31VW8V8A2                              BuildKite-Agent-staging
Build-Farm-Staging-AppServerGroupSpot-1IYM3SXFBVT26                                BuildKite-Agent-staging
Container-Service                                                                  Container-Service
MailCatcher-Production-StackApplication-18HDMPF3WZDWQ-AppServerGroup-FMPVR2QC4U17  mailcatcher-production
```

### Autoscale Group Capacity

```sh
~ λ  awsm asg-capacity Build-Farm-Production-AppServerGroupDemand-1SZ3RV6YFM36L
Build-Farm-Production-AppServerGroupDemand-1SZ3RV6YFM36L  3  3  3
```

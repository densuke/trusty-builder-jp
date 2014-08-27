# Ubuntu Linux 日本語版(相当)のISOイメージビルダー

このDockerイメージは、Ubuntu Linux 14.04LTS(Trusty Tahr)のインストールDVDを作成するものです。
日本語ISOイメージとして作っています。

これを使うことでこんなことができるかもしれません。

* 作りたくなったらいつでも最新版パッケージで構成されたインストールイメージを作れます
* ちょっと頑張れば、カスタマイズ版のCDも作成できると思います

# 基本の使い方


イメージ内でISOイメージを作ります、内部的には `/target` ディレクトリで作業して吐き出すため、ここを任意ディレクトリで上書きマウントしてください。なお、作業中のデータも置かれるため、 **空き容量8GB以上は用意しておいてください**。

  $ TARGET=/path/to/build/iso
  $ docker run --rm --privileged -v $TARGET:/target densuke/trusty-builder-jp 

これで放っておくと、 `$TARGET` に binary.hybrid.iso ファイルが出来上がります。 
煮るなり焼くなりしてください。
なお、dockerのコマンドラインで `--privileged` がついてますが、中でchrootしたりprocやsysのマウントを行うからです。

# カスタム化について

実はイメージ内の `/builder/config` ディレクトリにイメージ作成用の設定が置かれているいため、ここを上書きマウントすることで理論上カスタマイズ可能となっています(`-v /path/to/config:/builder/config`)。

(2014/8/28追加)
[http://archive.ubuntulinux.jp/ubuntu/pool/main/u/ubuntu-defaults-ja/](ubuntu-defaults-jaパッケージ)の中身をconfigとしておいているだけですので、内容を確認し、編集した後、

  $ TARGET=/path/to/build/iso
	$ CUSTOM=/path/to/config
  $ docker run --rm --privileged -v $TARGET:/target -v $CUSTOM:/builder/config densuke/trusty-builder-jp 

というかたちでマウントしてもらえれば反映出来る仕組みです。

  例:
	$ wget http://archive.ubuntulinux.jp/ubuntu/pool/main/u/ubuntu-defaults-ja/ubuntu-defaults-ja_14.04-0ubuntu1~ja6.dsc
	$ wget http://archive.ubuntulinux.jp/ubuntu/pool/main/u/ubuntu-defaults-ja/ubuntu-defaults-ja_14.04-0ubuntu1~ja6.tar.gz
	$ dpkg-source -x ubuntu-defaults-ja_14.04-0ubuntu1~ja6.dsc
	$ mv * config
	(いじる)
  $ docker run --rm --privileged -v $TARGET:/target -v $(PWD)/config:/builder/config densuke/trusty-builder-jp 


# 動作保証について

あたりまえですが、検証もろくにしてないシステムです。どうなっても知りませんので自己責任でお願いします。


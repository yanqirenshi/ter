# Ter

T字形ER図を作成したり、普通の ER図を作成したり

TER は以下のような構成になっています。
詳細はそれぞれの README を参照してください。

|                                                                               | Description |
|-------------------------------------------------------------------------------|-------------|
| [core](https://bitbucket.org/yanqirenshi/ter/src/master/core/README.markdown) | モデル      |
| [api](https://bitbucket.org/yanqirenshi/ter/src/master/api/README.markdown)   | WEB-API     |
| [web](https://bitbucket.org/yanqirenshi/ter/src/master/web/README.markdown)   | WEB         |

# Usage

```
(in-package :ter)
(import-schema.rb (get-schema-graph :your-schema-code) #P"/your/schema/project/file/path/db/schema.rb")
```

# Docker

https://hub.docker.com/r/renshi/ter/


# Author

+ Satoshi Iwasaki (yanqirenshi@gmail.com)

# Copyright

Copyright (c) 2018 Satoshi Iwasaki (yanqirenshi@gmail.com)

# License

MIT

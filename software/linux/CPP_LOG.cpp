#include "Log.h"

int main(int argc, char** argv) {
    //Config: -----(optional)----
    structlog LOGCFG = {};
    LOGCFG.headers = false;
    LOGCFG.level = DEBUG;
    //---------------------------
    LOG(INFO) << "Main executed with " << (argc - 1) << " arguments";
}

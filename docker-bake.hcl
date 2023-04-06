variable "GIT_REV" {
    default = ""
}

variable "REPO" {
    default = "shanemeyers/aws-role-login"
}


target "default" {
    args = {
        GIT_REV = "${GIT_REV}"
    }
    dockerfile = "Dockerfile"
    tags = [
        "${REPO}:latest",
        "${REPO}:git-${GIT_REV}",
    ]
    platforms = [
        "linux/arm64",
        "linux/amd64",
    ]
    pull = true
}

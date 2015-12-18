FROM rgielen/httpd-image-drush:latest

ENV BASE_DIR /var
ENV DRUPAL_PROJECT_NAME drupal
ENV DRUPAL_DIR ${BASE_DIR}/${DRUPAL_PROJECT_NAME}
ENV DRUPAL_MODULES_CUSTOM_DIR ${DRUPAL_DIR}/sites/all/modules/custom
ENV DRUPAL_THEMES_DIR ${DRUPAL_DIR}/sites/all/themes
ENV DRUPAL_FILES_DIR ${DRUPAL_DIR}/sites/default/files

COPY scripts/fix-drupal-permissions.sh /usr/local/bin

RUN apt-get update \
      && apt-get install -y --no-install-recommends \
        php5-curl libssh2-php php5-mysql php5-pgsql \
    && a2enmod rewrite php5

# If existent, drush will use contrib subdir for managed modules
# See https://www.drupal.org/node/371298
RUN cd ${BASE_DIR} && drush -y dl drupal-7 --drupal-project-rename ${DRUPAL_PROJECT_NAME} \
    && cd ${DRUPAL_DIR} \
    && mkdir sites/all/modules/contrib && mkdir sites/all/modules/custom && mkdir sites/default/files \
    && cp sites/default/default.settings.php sites/default/settings.php \
    && drush -y pm-download views \
    && groupadd -r drupal && useradd -r -g drupal drupal \
    && fix-drupal-permissions.sh --drupal_path=${DRUPAL_DIR} --drupal_user=drupal --httpd_group=www-data

VOLUME ${DRUPAL_MODULES_CUSTOM_DIR} ${DRUPAL_THEMES_DIR} ${DRUPAL_FILES_DIR}
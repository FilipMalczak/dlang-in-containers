ARG APP_NAME

FROM dlangchina/dlang-dmd:2.097.1

RUN mkdir -p /dapp

WORKDIR /dapp
COPY ./source/** ./source/
COPY ./dub.json .
RUN ls -la
RUN dub build
RUN ls -la

FROM dlangchina/dlang-dmd:2.097.1

RUN mkdir -p /$APP_NAME
WORKDIR /dapp
RUN echo a $APP_NAME b

COPY --from=0 /dapp/$APP_NAME /dapp
RUN chmod +x /dapp/$APP_NAME
RUN echo x $APP_NAME y

ENTRYPOINT [ "/dapp/$APP_NAME"]
CMD []

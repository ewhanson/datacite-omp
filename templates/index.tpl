{extends file="layouts/backend.tpl"}
{strip}
    {assign var="pageTitle" value="{translate key="plugins.importexport.crossref.displayName"}"}
{/strip}
{block name="page"}
	<h1 class="app__pageHeading">
		{$pageTitle|escape}
	</h1>

	<tabs label="Crossref XML Plugin Tabs">
		{* Settings *}
		<tab label="{translate key='plugins.importexport.crossref.settings'}" id="settings-tab-head">
			<div id="setting-tab">
				<script type="text/javascript">
					$(function () {ldelim}
							$('#crossrefSettingsForm').pkpHandler('$.pkp.controllers.form.FormHandler');
						{rdelim});
				</script>

				<form class="pkp_form" id="crossrefSettingsForm" method="post"
					  action="{plugin_url path="settings" verb="save"}">
					{csrf}
                    {if $doiPluginSettingsLinkAction}
                        {fbvFormArea id="doiPluginSettingsLink"}
                        {fbvFormSection}
                            {include file="linkAction/linkAction.tpl" action=$doiPluginSettingsLinkAction}
                        {/fbvFormSection}
                        {/fbvFormArea}
                    {/if}

                    {fbvFormArea id="crossrefSettingsFormArea"}
						<p class="pkp_help">{translate key="plugins.importexport.crossref.settings.description"}</p>
						<p class="pkp_help">{translate key="plugins.importexport.crossref.intro"}</p>
                    {fbvFormSection}
                    {fbvElement type="text" id="username" value=$username label="plugins.importexport.crossref.settings.form.username" maxlength="50" size=$fbvStyles.size.MEDIUM}
                    {fbvElement type="text" password="true" id="password" value=$password label="plugins.importexport.crossref.settings.form.password" maxLength="50" size=$fbvStyles.size.MEDIUM}
						<span class="instruct">{translate key="plugins.importexport.crossref.settings.form.password.description"}</span>
						<br/>
                    {/fbvFormSection}
                    {fbvFormSection list="true"}
                    {fbvElement type="checkbox" id="testMode" value=true label="plugins.importexport.crossref.settings.form.testMode.description" checked=$testMode|compare:true}
                    {/fbvFormSection}
                    {/fbvFormArea}

                    {fbvFormButtons submitText="common.save"}
				</form>
			</div>
		</tab>

		{* Queue *}
		<tab label="{translate key='plugins.importexport.crossref.queued'}" id="exportSubmissions-tab-head">
			<div id="exportSubmissions-tab">
				<script type="text/javascript">
					$(function () {ldelim}
						$('#queueXmlForm').pkpHandler('$.pkp.controllers.form.FormHandler',
							{
								trackFormChanges: false
							}
						);
                        {rdelim});
				</script>

				<form id="crossref-queueXmlForm" class="pkp_form" action="{plugin_url path='export'}" method="post">
					{csrf}

					<div id="crossrefexportlistgrid" class="pkp_controller_grid">
						<div>
							<ul aria-live="polite" style="padding: 0">
								{foreach $itemsQueue as $key=>$item}
									<li style="list-style-type: none;">
										<div style="display: flex;">
											<div style="padding-right: 4em;">
												<div>{$item["id"]}</div>
												<div><span class="-screenReader">ID</span></div>
											</div>
											<div>
												<div style="font-weight: 700;">
													{$item["authors"]}
												</div>
												<div>
													{$item["title"]}<br />
													DOI: {$item["pubId"]}<br />
													{if $item["chapterPubIds"]}
														{translate key="plugins.importexport.crossref.chapterDoiCount"}:  {$item["chapterPubIds"]|count}
													{/if}
												</div>
												<div style="margin-top: 0.5em; font-size: 12px; line-height: 1.5em;">
													{if $item["notices"]}
														{foreach from=$item["notices"] item=$notice}
															<span aria-hidden="true" class="fa fa-exclamation-triangle pkpIcon--inline"></span> {$notice|escape} <br />
														{/foreach}
													{/if}
													{if $item["errors"]}
														{foreach from=$item["errors"] item=$error}
															<span aria-hidden="true" class="fa fa-exclamation-triangle pkpIcon--inline"></span> {$error} <br />
														{/foreach}
													{/if}
												</div>
											</div>
											<div style="padding-left: 4em;">
												<div>
													{if !$item["errors"]}
														<button class="pkpBadge pkpBadge--button pkpBadge--dot">
															<a href="{$plugin}/export?submission={$item["id"]}" class="">
																{translate key="plugins.importexport.crossref.deposit"}
															</a>
														</button>
													{/if}
													<div aria-hidden="true"
														 class="Item--submission__flags">
													</div>
												</div>
											</div>
										</div>
									</li>
								{/foreach}
							</ul>
							<div style="font-size: 12px; line-height: 24px;">
								{$itemsSizeQueue} submissions
							</div>
						</div>
					</div>
				</form>

			</div>
		</tab>

		<tab label="{translate key='plugins.importexport.crossref.deposited'}" id="depositedSubmissions-tab-head">
			<div id="depositedSubmissions-tab">
				<script type="text/javascript">
					$(function () {ldelim}
						$('#depositedXmlForm').pkpHandler('$.pkp.controllers.form.FormHandler');
                        {rdelim});
				</script>

				<form id="depositedXmlForm" class="pkp_form" action="{plugin_url path="export"}" method="post">
                    {csrf}
					<div id="crossrefdepositedlistgrid" class="pkp_controller_grid">
						<div>
							<ul aria-live="polite" style="padding: 0">
                                {foreach $itemsDeposited as $key=>$item}
									<li style="list-style-type: none;">
										<div style="display: flex;">
											<div style="padding-right: 4em;">
												<div>{$item["id"]}</div>
												<div><span class="-screenReader">ID</span></div>
											</div>
											<div>
												<div style="font-weight: 700;">
                                                    {$item["authors"]}
												</div>
												<div>
                                                    {$item["title"]}<br />
													DOI: {$item["pubId"]}<br />
                                                    {if $item["chapterPubIds"]}
                                                        {translate key="plugins.importexport.crossref.chapterDoiCount"}:  {$item["chapterPubIds"]|count}
                                                    {/if}
												</div>
												<div style="margin-top: 0.5em; font-size: 12px; line-height: 1.5em;">
                                                    {if $item["notices"]}
                                                        {foreach from=$item["notices"] item=$notice}
															<span aria-hidden="true" class="fa fa-exclamation-triangle pkpIcon--inline"></span> {$notice|escape} <br />
                                                        {/foreach}
                                                    {/if}
                                                    {if $item["errors"]}
                                                        {foreach from=$item["errors"] item=$error}
															<span aria-hidden="true" class="fa fa-exclamation-triangle pkpIcon--inline"></span> {$error} <br />
                                                        {/foreach}
                                                    {/if}
												</div>
											</div>
											<div style="padding-left: 4em;">
												<div>
                                                    {if !$item["errors"]}
														<button class="pkpBadge pkpBadge--button pkpBadge--dot">
															<a href="{$plugin}/export?submission={$item["id"]}" class="">
                                                                {translate key="plugins.importexport.crossref.redeposit"}
															</a>
														</button>
                                                    {/if}
													<div aria-hidden="true"
														 class="Item--submission__flags">
													</div>
												</div>
											</div>
										</div>
									</li>
                                {/foreach}
							</ul>
							<div style="font-size: 12px; line-height: 24px;">
                                {$itemsSizeDeposited} submissions
							</div>
						</div>
					</div>
				</form>
			</div>
		</tab>

	</tabs>
{/block}
